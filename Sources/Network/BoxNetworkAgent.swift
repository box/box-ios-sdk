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

    // The variable "session" is set as lazy here because self can't be passed as a delegate
    // until after init is finished. It will be computed after init and then used in other
    // functions in this class.
    private lazy var session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)

    /// Initializer.
    ///
    /// - Parameter configuration: Box SDK configuration. If nil, default configuration is used.
    public init(
        configuration: BoxSDKConfiguration = BoxSDK.defaultConfiguration
    ) {
        self.configuration = configuration
        if let fileDestination = configuration.fileLogDestination {
            logger = Logger(category: .networkAgent, destinations: [configuration.consoleLogDestination, fileDestination])
        }
        else {
            logger = Logger(category: .networkAgent, destinations: [configuration.consoleLogDestination])
        }
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

        let urlRequest = createRequest(for: updatedRequest)
        // swiftlint:disable:next force_unwrapping
        let downloadDestination = request.downloadDestination!
        var observation: NSKeyValueObservation?

        let task = session.downloadTask(with: urlRequest) { [weak self] location, response, error in
            guard let self = self else {
                return
            }

            observation?.invalidate()

            if let unwrappedError = error {
                completion(.failure(BoxNetworkError(message: .customValue(unwrappedError.localizedDescription), error: unwrappedError)))
                self.logger.error("Request Error: %{public}@", unwrappedError.localizedDescription)
                return
            }

            guard let localURL = location else {
                completion(.failure(BoxAPIError(message: "File was not downloaded", request: request, response: BoxResponse(
                    request: request,
                    body: nil,
                    urlResponse: response
                ))))
                return
            }

            do {
                try? FileManager.default.removeItem(at: downloadDestination) // remove the old file, if any
                try FileManager.default.moveItem(at: localURL, to: downloadDestination)
            }
            catch {
                completion(.failure(BoxSDKError(message: "Could not move item from temporary download location to download destination")))
            }

            self.processResponse(
                BoxResponse(
                    request: request,
                    body: nil,
                    urlResponse: response
                ),
                retryCount: retryCount,
                retry: { [weak self] in
                    self?.sendDownloadRequest(request: request, retryCount: retryCount + 1, completion: completion)
                },
                completion: completion
            )
        }

        // Key value observer: Observer attaches to Progress object on task. Every time the Progress object updates, the callback is called
        observation = task.progress.observe(\Progress.fractionCompleted, options: [.new]) { progress, _ in
            request.progress(progress)
        }

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

        let urlRequest = createRequest(for: updatedRequest)
        var observation: NSKeyValueObservation?

        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else {
                return
            }

            observation?.invalidate()

            if let unwrappedError = error {
                completion(.failure(BoxNetworkError(message: .customValue(unwrappedError.localizedDescription), error: unwrappedError)))
                self.logger.error("Request Error: %{public}@", unwrappedError.localizedDescription)
                return
            }

            self.processResponse(
                BoxResponse(
                    request: request,
                    body: data,
                    urlResponse: response
                ),
                retryCount: retryCount,
                retry: { [weak self] in
                    self?.send(request: request, retryCount: retryCount + 1, completion: completion)
                },
                completion: completion
            )
        }

        // Key value observer: Observer attaches to Progress object on task. Every time the Progress object updates, the callback is called
        observation = task.progress.observe(\Progress.fractionCompleted, options: [.new]) { progress, _ in
            request.progress(progress)
        }

        utilityQueue.async {
            task.resume()
        }
    }

    private func createRequest(for request: BoxRequest) -> URLRequest {
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
        return urlRequest
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
