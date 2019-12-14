import Foundation
import os

/// Represents API request query parameters.
public typealias QueryParameters = [String: QueryParameterConvertible?]

/// Represents HTTP headers for API requests.
public typealias BoxHTTPHeaders = [String: String]

/// HTTPHeader key constants
enum BoxHTTPHeaderKey {
    static let authorization = "Authorization"
    static let ifMatch = "If-Match"
    static let asUser = "As-User"
    static let boxApi = "BoxApi"
}

/// BoxApi header key constants
enum BoxAPIHeaderKey {
    static let sharedLink = "shared_link"
    static let sharedLinkPassword = "shared_link_password"
}

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
    case options
}

struct Request {
    var request: BoxRequest?
    var retryCount: Int?
    var completion: Callback<BoxResponse>?
    var downloadDestination: URL?
    var stream: InputStream?
}

// Error codes allowing for request retry
private let transientErrorCodes = [429, 500, 501, 502, 503, 504]

/// Defines networking layer interface
public protocol NetworkAgentProtocol {
    /// Makes a Box SDK request
    ///
    /// - Parameters:
    ///   - request: Box SDK request
    ///   - completion: Returns standard BoxResponse object or error.
    func send(
        request: BoxRequest,
        completion: @escaping Callback<BoxResponse>
    )
}

/// Implementation of networking layer
public class BoxNetworkAgent: NSObject, NetworkAgentProtocol {
    private let analyticsHeaderGenerator = AnalyticsHeaderGenerator()
    private let configuration: BoxSDKConfiguration
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let logger: Logger
    // Struct with request information for download, upload and regular requests to be used when by the delegate methods
    private var storedRequest = Request()
    // This is a Lazy variable because you can't pass in self in as delegate until init method is finished. So now, this variable will compute
    // after init when it is actually used in other functions in this class
    private lazy var session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)

    /// Initializer.
    ///
    /// - Parameter configuration: Box SDK configuration. If nil, default configuration is used.
    public init(
        configuration: BoxSDKConfiguration = BoxSDK.defaultConfiguration
    ) {
        self.configuration = configuration
        logger = Logger(category: .networkAgent, destinations: [configuration.consoleLogDestination])
    }

    /// Makes Box SDK request
    ///
    /// - Parameters:
    ///   - request: Box SDK request
    ///   - completion: Returns standard BoxResponse object or error.
    public func send(
        request: BoxRequest,
        completion: @escaping Callback<BoxResponse>
    ) {
        if request.downloadDestination != nil {
            sendDownloadRequest(request: request, retryCount: 0, completion: completion)
        }
        else {
            send(request: request, retryCount: 0, completion: completion)
        }
    }

    private func sendDownloadRequest(
        request: BoxRequest,
        retryCount: Int,
        completion: @escaping Callback<BoxResponse>
    ) {
        let updatedRequest = updateRequestWithAnalyticsHeaders(request)
        logger.logRequest(updatedRequest)

        storedRequest.request = request
        storedRequest.retryCount = retryCount
        storedRequest.completion = completion

        let task = createDownloadRequest(for: updatedRequest)

        var observation: NSKeyValueObservation?
        let progressHandler: (Progress, NSKeyValueObservedChange<Double>) -> Void = {
            progress, _ in
            request.progress(progress)
            if progress.fractionCompleted >= 1 {
                observation?.invalidate()
                observation = nil
            }
        }
        observation = task.progress.observe(\Progress.fractionCompleted, options: [.new], changeHandler: progressHandler)

//        request.progress(task.progress)
        utilityQueue.async {
            task.resume()
        }
    }

    private func send(
        request: BoxRequest,
        retryCount: Int,
        completion: @escaping Callback<BoxResponse>
    ) {

        let updatedRequest = updateRequestWithAnalyticsHeaders(request)
        logger.logRequest(updatedRequest)

        storedRequest.request = request
        storedRequest.retryCount = retryCount
        storedRequest.completion = completion

        let task = createRequest(for: updatedRequest)
        let progress = Progress(totalUnitCount: task.countOfBytesClientExpectsToReceive)
        progress.completedUnitCount = task.countOfBytesReceived
        request.progress(progress)
        utilityQueue.async {
            task.resume()
        }
    }

    private func createRequest(for request: BoxRequest) -> URLSessionTask {
        let method = request.httpMethod.rawValue.uppercased()
        let url = request.endpoint()
        let headers = request.httpHeaders

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.allHTTPHeaderFields = headers

        switch request.body {
        case .empty:
            break
        case let .jsonObject(json):
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
        case let .jsonArray(jsonArray):
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
            urlRequest.httpBody = jsonData
        case let .urlencodedForm(params):
            let urlencodedForm = params
                .map { key, value in
                    String(
                        format: "%@=%@",
                        // swiftlint:disable:next force_unwrapping
                        key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                        // swiftlint:disable:next force_unwrapping
                        value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    )
                }
                .joined(separator: "&")
                .data(using: .utf8)
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = urlencodedForm
        case let .data(data):
            urlRequest.httpBody = data
        case let .multipart(body):
            var parameters: [String: Any] = [:]
            var partName = ""
            var fileName = ""
            var mimeType = ""
            var bodyStream = InputStream()
            let boundary = "Boundary-\(UUID().uuidString)"
            for part in body.getParts() {
                switch part.contents {
                case let .data(data):
                    parameters[part.name] = String(decoding: data, as: UTF8.self)
                case let .stream(stream):
                    guard let unwrapFileName = part.fileName,
                        let unwrapMimeType = part.mimeType else {
                        fatalError("Could not get file name or type from multipart request body - \(part)")
                    }
                    partName = part.name
                    fileName = unwrapFileName
                    mimeType = unwrapMimeType
                    bodyStream = stream
                }
            }
            let bodyStreams = createMultipartBodyStreams(parameters, partName: partName, fileName: fileName, mimetype: mimeType, bodyStream: bodyStream, boundary: boundary)
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.httpBodyStream = ArrayInputStream(inputStreams: bodyStreams)
        }
        return session.dataTask(with: urlRequest)
    }

    func createMultipartBodyStreams(_ parameters: [String: Any]?, partName: String, fileName: String, mimetype: String, bodyStream: InputStream, boundary: String) -> [InputStream] {
        // swiftlint:disable force_unwrapping
        var preBody = Data()
        if parameters != nil {
            for (key, value) in parameters! {
                preBody.append("--\(boundary)\r\n".data(using: .utf8)!)
                preBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                preBody.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        preBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        preBody.append("Content-Disposition: form-data; name=\"\(partName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        preBody.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)

        var postBody = Data()
        postBody.append("\r\n".data(using: .utf8)!)
        postBody.append("--\(boundary)--\r\n".data(using: .utf8)!)

        var bodyStreams: [InputStream] = []
        bodyStreams.append(InputStream(data: preBody))
        bodyStreams.append(bodyStream)
        bodyStreams.append(InputStream(data: postBody))

        return bodyStreams
        // swiftlint:enable force_unwrapping
    }

    private func createDownloadRequest(for request: BoxRequest) -> URLSessionDownloadTask {
        let method = request.httpMethod.rawValue.uppercased()
        let url = request.endpoint()
        let headers = request.httpHeaders

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.allHTTPHeaderFields = headers

        if let unwrappedDestination = request.downloadDestination {
            storedRequest.downloadDestination = unwrappedDestination
        }
        else {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            storedRequest.downloadDestination = urls.last
        }
        return session.downloadTask(with: urlRequest)
    }

    private func updateRequestWithAnalyticsHeaders(_ request: BoxRequest) -> BoxRequest {
        let updatedRequest = request
        updatedRequest.httpHeaders["X-Box-UA"] = analyticsHeaderGenerator.analyticsHeader(forConfiguration: configuration)
        return updatedRequest
    }

    // Needs to be internal to accommodate tests
    func processResponse(
        _ response: BoxResponse,
        retryCount: Int,
        retry: @escaping () -> Void,
        completion: @escaping Callback<BoxResponse>
    ) {
        logger.logResponse(response)

        guard let httpResponse = response.urlResponse else {
            completion(.failure(BoxAPIError(message: "Invalid response", response: response)))
            logger.error("Request Error: Invalid response")
            return
        }

        let statusCode = httpResponse.statusCode
        if statusCode == 401 {
            completion(.failure(BoxAPIAuthError(message: .unauthorizedAccess, response: response)))
            return
        }

        if transientErrorCodes.contains(statusCode) {
            if retryCount == configuration.maxRetryAttempts {
                completion(.failure(BoxNetworkError(message: .rateLimitMaxRetries)))
                return
            }

            let expFactor = pow(2.0, Double(retryCount))
            let jitter = 1 + Double.random(in: -0.5 ... 0.5)
            let delay = expFactor * configuration.retryBaseInterval * jitter

            logger.debug("Retrying request in: %0.3fs", delay)

            retryRequest(retry, afterDelay: delay)
            return
        }

        // Check for error status codes here and automatically transform those responses into errors
        guard 200 ..< 400 ~= statusCode else {
            return completion(.failure(BoxAPIError(request: response.request, response: response)))
        }

        completion(.success(response))
    }

    func retryRequest(_ retry: @escaping () -> Void, afterDelay delay: TimeInterval) {
        utilityQueue.asyncAfter(deadline: .now() + .milliseconds(Int(delay * 1000))) {
            retry()
        }
    }
}

extension BoxNetworkAgent: URLSessionDownloadDelegate {
    // swiftlint:disable all
    public func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData _: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Progress(totalUnitCount: totalBytesExpectedToWrite)
        progress.completedUnitCount = totalBytesWritten
//        storedRequest.request?.progress(progress)

//        if totalBytesExpectedToWrite > 0 {
//            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
//            print("Progress \(downloadTask) \(progress)")
//        }
    }

    public func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        let request = storedRequest.request!
        let retryCount = storedRequest.retryCount!
        let completion = storedRequest.completion!
        let downloadDestination = storedRequest.downloadDestination!

        do {
            try? FileManager.default.removeItem(at: downloadDestination) // remove the old file, if any
            try FileManager.default.moveItem(at: location, to: downloadDestination)
        }
        catch {
            completion(.failure(BoxSDKError(error: error)))
            return
        }

        processResponse(
            BoxResponse(
                request: request,
                body: nil,
                urlResponse: downloadTask.response
            ),
            retryCount: retryCount,
            retry: { [weak self] in
                self?.sendDownloadRequest(request: request, retryCount: retryCount + 1, completion: completion)
            },
            completion: completion
        )
    }

    public func urlSession(_: URLSession, task _: URLSessionTask, didCompleteWithError error: Error?) {
        let completion = storedRequest.completion!

        if let unwrappedError = error {
            completion(.failure(BoxNetworkError(message: .customValue(unwrappedError.localizedDescription))))
            logger.error("Request Error: %{public}@", unwrappedError.localizedDescription)
            return
        }
    }
}

extension BoxNetworkAgent: URLSessionDataDelegate {
    // swiftlint:disable all

    // Handles all requests other than uploads
    public func urlSession(_: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        let request = storedRequest.request!
        let retryCount = storedRequest.retryCount!
        let completion = storedRequest.completion!

        processResponse(
            BoxResponse(
                request: request,
                body: data,
                urlResponse: dataTask.response
            ),
            retryCount: retryCount,
            retry: { [weak self] in
                self?.send(request: request, retryCount: retryCount + 1, completion: completion)
            },
            completion: completion
        )
    }

//    public func urlSession(_: URLSession, dataTask: URLSessionDataTask, didReceive _: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
//        // We've got the response headers from the server.
//        print("didReceive response")
    ////        self.response = response
//
    ////        let request = storedRequest.request!
    ////        let retryCount = storedRequest.retryCount!
    ////        let completion = storedRequest.completion!
    ////
    ////        processResponse(
    ////            BoxResponse(
    ////                request: request,
    ////                body: nil,
    ////                urlResponse: dataTask.response
    ////            ),
    ////            retryCount: retryCount,
    ////            retry: { [weak self] in
    ////                self?.send(request: request, retryCount: retryCount + 1, completion: completion)
    ////            },
    ////            completion: completion
    ////        )
//
//        completionHandler(URLSession.ResponseDisposition.allow)
//    }

    // Next few functions handle upload requests

    public func urlSession(_: URLSession, task _: URLSessionTask, didSendBodyData _: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Progress(totalUnitCount: totalBytesExpectedToSend)
        progress.completedUnitCount = totalBytesSent
        storedRequest.request?.progress(progress)
    }
}

// extension URLSessionDownloadTask {
//
//    public var test = 1234
//
// }

// extension URLRequest{
//    var boxRequest: Request = Request()
//
// }
