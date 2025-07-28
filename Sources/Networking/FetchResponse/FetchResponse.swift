import Foundation

/// Response of the fetch call
public class FetchResponse {
    /// HTTP status code of the response
    public let status: Int

    /// HTTP headers of the response
    public let headers: [String: String]

    /// URL of the response
    public let url: String?

    /// Response body of the response
    public let data: SerializedData?

    /// The URL on disk where the file was saved
    public let downloadDestinationUrl: URL?

    /// Initializer for a FetchResponse.
    ///
    /// - Parameters:
    ///   - status: HTTP status code of the response
    ///   - headers: HTTP headers of the response
    ///   - url: URL of the response
    ///   - data: Response body of the response
    ///   - downloadDestinationUrl: The URL on disk where the file was saved
    public init(status: Int, headers: [String: String], url: String? = nil, data: SerializedData? = nil, downloadDestinationUrl: URL? = nil) {
        self.status = status
        self.headers = headers
        self.url = url
        self.data = data
        self.downloadDestinationUrl = downloadDestinationUrl
    }

}
