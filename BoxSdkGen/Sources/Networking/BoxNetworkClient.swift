import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Networking layer interface
public class BoxNetworkClient: NetworkClient {

    private let utilityQueue = DispatchQueue.global(qos: .utility)

    public init(){}

    /// Executes requests
    ///
    /// - Parameters:
    ///   - options: Request options  that provides request-specific information, such as the request type, and body, query parameters.
    /// - Returns: Response of the request in the form of FetchResponse object.
    /// - Throws: An error if the request fails for any reason.
    public func fetch(options: FetchOptions) async throws -> FetchResponse {
        var options = options
        if let fileStream = options.fileStream, !(fileStream is MemoryInputStream) {
            let memoryInputStream = MemoryInputStream(data: Utils.readByteStream(byteStream: fileStream))
            options = options.withFileStream(fileStream: memoryInputStream)
        }

        return try await fetch(
            options: options,
            networkSession: options.networkSession ?? NetworkSession(),
            attempt: 1
        )
    }

    /// Executes requests
    ///
    /// - Parameters:
    ///   - options: Request options  that provides request-specific information, such as the request type, and body, query parameters.
    ///   - networkSession: The Networking Session object which provides the URLSession object along with a network configuration parameters used in network communication.
    ///   - attempt: The request attempt number.
    /// - Returns: Response of the request in the form of FetchResponse object.
    /// - Throws: An error if the request fails for any reason.
    private func fetch(
        options: FetchOptions,
        networkSession: NetworkSession,
        attempt: Int
    ) async throws -> FetchResponse {
        let urlRequest = try await createRequest(
            options: options,
            networkSession: networkSession
        )

        if let fileStream = options.fileStream, let memoryInputStream = fileStream as? MemoryInputStream, attempt > 1 {
            memoryInputStream.reset()
        }

        if let downloadDestinationUrl = options.downloadDestinationUrl, options.responseFormat == .binary {
            let (downloadUrl, urlResponse) = try await sendDownloadRequest(urlRequest, downloadDestinationURL: downloadDestinationUrl, networkSession: networkSession)
            let conversation = FetchConversation(options: options, urlRequest: urlRequest, urlResponse: urlResponse as! HTTPURLResponse, responseType: .url(downloadUrl))
            return try await processResponse(using: conversation, networkSession: networkSession, attempt: attempt)
        } else {
            let (data, urlResponse) =  try await sendDataRequest(urlRequest, networkSession: networkSession)
            let conversation = FetchConversation(options: options, urlRequest: urlRequest, urlResponse: urlResponse as! HTTPURLResponse, responseType: .data(data))
            return try await processResponse(using: conversation, networkSession: networkSession, attempt: attempt)
        }
    }

    /// Executes data request using dataTask and converts it's callback based API into an async API.
    ///
    /// - Parameters:
    ///   - urlRequest: The request object.
    ///   - networkSession: The Networking Session object which provides the URLSession object along with a network configuration parameters used in network communication.
    /// - Returns: Tuple of  of (Data, URLResponse)
    /// - Throws: An error if the request fails for any reason.
    private func sendDataRequest(_ urlRequest: URLRequest, networkSession: NetworkSession) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            networkSession.session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(with: .failure(BoxNetworkError(message: error.localizedDescription, error: error)))
                    return
                }

                guard let response = response else {
                    continuation.resume(
                        with: .failure(BoxNetworkError(message: "No response \(urlRequest.url?.absoluteString ?? "")."))
                    )
                    return
                }

                continuation.resume(
                    with: .success((data ?? Data(), response))
                )
            }
            .resume()
        }
    }

    /// Executes download request using downloadTask and converts it's callback based API into an async API.
    ///
    /// - Parameters:
    ///   - urlRequest: The request object.
    ///   - networkSession: The Networking Session object which provides the URLSession object along with a network configuration parameters used in network communication.
    /// - Returns: Tuple of  of (URL, URLResponse)
    /// - Throws: An error if the request fails for any reason.
    private func sendDownloadRequest(_ urlRequest: URLRequest, downloadDestinationURL: URL, networkSession: NetworkSession) async throws -> (URL, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            networkSession.session.downloadTask(with: urlRequest) { location, response, error in
                if let error = error {
                    continuation.resume(with: .failure(BoxNetworkError(message: error.localizedDescription, error: error)))
                    return
                }

                guard let localURL = location else {
                    continuation.resume(
                        with: .failure(BoxNetworkError(message: "File was not downloaded \(urlRequest.url?.absoluteString ?? "")"))
                    )
                    return
                }

                guard let response = response else {
                    continuation.resume(
                        with: .failure(BoxNetworkError(message: "No response \(urlRequest.url?.absoluteString ?? "")."))
                    )
                    return
                }

                do {
                    try? FileManager.default.removeItem(at: downloadDestinationURL)
                    try FileManager.default.moveItem(at: localURL, to: downloadDestinationURL)
                }
                catch {
                    continuation.resume(
                        with: .failure(BoxSDKError(message: "Could not move item from temporary download location \(localURL.absoluteString) to download destination \(downloadDestinationURL.absoluteString)."))
                    )
                }

                continuation.resume(
                    with: .success((downloadDestinationURL, response))
                )
            }.resume()
        }
    }

    /// Creates the request object `URLRequest` based on  parameters passed in `options`.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - options: Request options  that provides request-specific information, such as the request type, and body, query parameters.
    ///   - networkSession: The Networking Session object which provides the URLSession object along with a network configuration parameters used in network communication.
    /// - Returns: The URLRequest object which represents information about the request.
    /// - Throws: An error if the operation fails for any reason.
    private func createRequest(
        options: FetchOptions,
        networkSession: NetworkSession
    ) async throws -> URLRequest {
        var urlRequest = URLRequest(url: createEndpointUrl(url: options.url, params: options.params))
        urlRequest.httpMethod = options.method.uppercased()

        try await updateRequestWithHeaders(&urlRequest, options: options, networkSession: networkSession)

        if let fileStream = options.fileStream {
            urlRequest.httpBodyStream = fileStream
        } else if let multipartData = options.multipartData {
            try updateRequestWithMultipartData(&urlRequest, multipartData: multipartData)
        }

        if let serializedData = options.data {
            if HTTPHeaderContentTypeValue.urlEncoded == options.contentType {
                urlRequest.httpBody = (try serializedData.toUrlParams()).data(using: .utf8)
            } else {
                urlRequest.httpBody = try serializedData.toJson()
            }
        }

        return urlRequest
    }

    /// Updates the passed request object `URLRequest` with headers,  based on  parameters passed in `options`.
    ///
    /// - Parameters:
    ///   - urlRequest: The request object.
    ///   - options: Request options  that provides request-specific information, such as the request type, and body, query parameters.
    ///   - networkSession: The Networking Session object which provides the URLSession object along with a network configuration parameters used in network communication.
    /// - Throws: An error if the operation fails for any reason.
    private func updateRequestWithHeaders(_ urlRequest: inout URLRequest, options: FetchOptions, networkSession: NetworkSession) async throws {
        urlRequest.allHTTPHeaderFields = options.headers

        for (key, value) in networkSession.additionalHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        urlRequest.setValue(options.contentType, forHTTPHeaderField: HTTPHeaderKey.contentType)

        for (key, value) in BoxConstants.analyticsHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        try await updateRequestWithAuthorizationHeader(&urlRequest, options: options, networkSession: networkSession)
    }

    /// Updates the passed request object `URLRequest` with authorization header,  based on  parameters passed in `options`.
    ///
    /// - Parameters:
    ///   - urlRequest: The request object.
    ///   - options: Request options  that provides request-specific information, such as the request type, and body, query parameters.
    ///   - networkSession: The Networking Session object which provides the URLSession object along with a network configuration parameters used in network communication.
    /// - Throws: An error if the operation fails for any reason.
    private func updateRequestWithAuthorizationHeader(_ urlRequest: inout URLRequest, options: FetchOptions, networkSession: NetworkSession) async throws {
        if let auth = options.auth {
            let authHeaderValue = try await auth.retrieveAuthorizationHeader(networkSession: networkSession)
            urlRequest.setValue(authHeaderValue, forHTTPHeaderField: HTTPHeaderKey.authorization)
        }
    }

    /// Updates the passed request object `URLRequest` with multipart data,  based on  parameters passed in `multipartData`.
    ///
    /// - Parameters:
    ///   - urlRequest: The request object.
    ///   - multipartData: An array of `MultipartItem` which will be used to create the body of the request.
    private func updateRequestWithMultipartData(_ urlRequest: inout URLRequest, multipartData: [MultipartItem]) throws {
        var parameters: [String: Any] = [:]
        var partName = ""
        var fileName = ""
        var mimeType = ""
        var bodyStream = InputStream(data: Data())
        let boundary = "Boundary-\(UUID().uuidString)"
        for part in multipartData {
            if let body = part.data {
                parameters[part.partName] = Utils.Strings.from(data: try body.toJson())
            } else if let fileStream = part.fileStream {
                let unwrapFileName = part.fileName ?? ""
                let unwrapMimeType = part.contentType ?? ""

                partName = part.partName
                fileName = unwrapFileName
                mimeType = unwrapMimeType
                bodyStream = fileStream
            }
        }

        let bodyStreams = createMultipartBodyStreams(parameters, partName: partName, fileName: fileName, mimetype: mimeType, bodyStream: bodyStream, boundary: boundary)
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: HTTPHeaderKey.contentType)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBodyStream = ArrayInputStream(inputStreams: bodyStreams)
    }

    /// Creates an array of `InputStream`based on passed arguments, which will be used as an bodyStream of the request.
    ///
    /// - Parameters:
    ///   - parameters: The parameters of the multipart request in form of a Dictionary.
    ///   - partName: The name of the file part.
    ///   - fileName: The file name.
    ///   - mimetype: The content type of the file part.
    ///   - bodyStream: The stream containing the file contents.
    ///   - boundary: The boundary value,  used to separate name/value pair.
    /// - Returns: An array of `InputStream`streams.
    private func createMultipartBodyStreams(_ parameters: [String: Any]?, partName: String, fileName: String, mimetype: String, bodyStream: InputStream, boundary: String) -> [InputStream] {
        var preBody = Data()
        if let parameters = parameters {
            for (key, value) in parameters {
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
    }

    /// Creates a `URL`object  based on url and query parameters
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - params: Query parameters to be passed in the URL.
    /// - Returns: The URL of the endpoint.
    private func createEndpointUrl(url: String, params: [String: ParameterConvertible?]?) -> URL {
        guard let params = params else {
            return URL(string: url)!
        }

        let nonNullQueryParams: [String: String] = params.compactMapValues { $0?.paramValue }
        var components = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: true)!
        components.queryItems = nonNullQueryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        return components.url!
    }

    /// Processes  response and performs the appropriate action
    ///
    /// - Parameters:
    ///   - using: Represents a data combined with the request and the corresponding response.
    ///   - networkSession: The Networking Session object which provides the URLSession object along with a network configuration parameters used in network communication.
    ///   - attempt: The request attempt number.
    /// - Returns: Response of the request in the form of FetchResponse object.
    /// - Throws: An error if the operation fails for any reason.
    private func processResponse(
        using conversation: FetchConversation,
        networkSession: NetworkSession,
        attempt: Int
    ) async throws -> FetchResponse {
        let statusCode = conversation.urlResponse.statusCode
        let isStatusCodeAcceptedWithRetryAfterHeader = statusCode == 202 && conversation.urlResponse.value(forHTTPHeaderField: HTTPHeaderKey.retryAfter) != nil

        // OK
        if statusCode >= 200 && statusCode < 400 && (!isStatusCodeAcceptedWithRetryAfterHeader || attempt >= networkSession.networkSettings.maxRetryAttempts) {
            return conversation.convertToFetchResponse()
        }

        // available attempts exceeded
        if attempt >= networkSession.networkSettings.maxRetryAttempts {
            throw BoxAPIError(fromConversation: conversation, message: "Request has hit the maximum number of retries.")
        }

        // Unauthorized
        if statusCode == 401, let auth = conversation.options.auth  {
            _ = try await auth.refreshToken(networkSession: networkSession)
            return try await fetch(options: conversation.options, networkSession: networkSession, attempt: attempt + 1)
        }

        // Retryable
        if statusCode == 429 || statusCode >= 500 || isStatusCodeAcceptedWithRetryAfterHeader {
            let retryTimeout = Double(conversation.urlResponse.value(forHTTPHeaderField: HTTPHeaderKey.retryAfter) ?? "")
            ?? networkSession.networkSettings.retryStrategy.getRetryTimeout(attempt: attempt)
            try await wait(seconds: retryTimeout)

            return try await fetch(options: conversation.options, networkSession: networkSession, attempt: attempt + 1)
        }

        throw BoxAPIError(fromConversation: conversation)
    }

    /// Suspends the current task for the given duration of seconds.
    ///
    /// - Parameters:
    ///   - seconds: Number of seconds to wait.
    /// - Throws: An error if the operation fails for any reason.
    private func wait(seconds delay: TimeInterval) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            utilityQueue.asyncAfter(
                deadline: .now() + .milliseconds(Int(delay * 1000))
            ) {
                continuation.resume()
            }
        }
    }
}
