import Foundation

public class FetchOptions {
    /// URL of the request
    public let url: String

    /// HTTP verb of the request
    public let method: String

    /// HTTP query parameters
    public let params: [String: String]?

    /// HTTP headers
    public let headers: [String: String]?

    /// Request body of the request
    public let data: SerializedData?

    /// Stream data of the request
    public let fileStream: InputStream?

    /// Multipart data of the request
    public let multipartData: [MultipartItem]?

    /// Content type of the request body
    public let contentType: String

    /// Expected response format
    public let responseFormat: ResponseFormat

    /// The URL on disk where the file will be saved
    public let downloadDestinationUrl: URL?

    /// Authentication object
    public let auth: Authentication?

    /// Network session object
    public let networkSession: NetworkSession?

    /// Initializer for a FetchOptions.
    ///
    /// - Parameters:
    ///   - url: URL of the request
    ///   - method: HTTP verb of the request
    ///   - params: HTTP query parameters
    ///   - headers: HTTP headers
    ///   - data: Request body of the request
    ///   - fileStream: Stream data of the request
    ///   - multipartData: Multipart data of the request
    ///   - contentType: Content type of the request body
    ///   - responseFormat: Expected response format
    ///   - downloadDestinationUrl: The URL on disk where the file will be saved
    ///   - auth: Authentication object
    ///   - networkSession: Network session object
    public init(url: String, method: String, params: [String: String]? = nil, headers: [String: String]? = nil, data: SerializedData? = nil, fileStream: InputStream? = nil, multipartData: [MultipartItem]? = nil, contentType: String = "application/json", responseFormat: ResponseFormat = ResponseFormat.json, downloadDestinationUrl: URL? = nil, auth: Authentication? = nil, networkSession: NetworkSession? = nil) {
        self.url = url
        self.method = method
        self.params = params
        self.headers = headers
        self.data = data
        self.fileStream = fileStream
        self.multipartData = multipartData
        self.contentType = contentType
        self.responseFormat = responseFormat
        self.downloadDestinationUrl = downloadDestinationUrl
        self.auth = auth
        self.networkSession = networkSession
    }

}
