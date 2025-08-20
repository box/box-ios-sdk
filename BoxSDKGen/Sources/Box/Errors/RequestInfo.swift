import Foundation
/// The class that represents the request information.
public class RequestInfo {
    /// The HTTP method for the Request
    public let method: String
    /// The URL the Request is sent to
    public let url: String
    /// The query parameters sent in the Request
    public let queryParams: [String: String]
    /// The HTTP headers sent in the Request
    public let headers: [String: String]
    /// The body of the Request
    public let body: String?

    /// Initializer
    ///
    /// - Parameters:
    ///   - method: The HTTP method for the Request
    ///   - url: The URL the Request is sent to
    ///   - queryParams: The query parameters sent in the Request
    ///   - headers: The HTTP headers sent in the Request
    ///   - body: The body of the Request
    public init(method: String, url: String, queryParams: [String: String], headers: [String: String], body: String? = nil) {
        self.method = method
        self.url = url
        self.queryParams = queryParams
        self.headers = headers
        self.body = body
    }

}

extension RequestInfo {
    /// Get a dictionary representing a `RequestInfo`.
    ///
    /// - Returns: A dictionary representing a `RequestInfo`.
    func getDictionary(dataSanitizer: DataSanitizer) -> [String: Any] {
        var dict = [String: Any]()
        dict["method"] = method
        dict["url"] = url
        dict["queryParams"] = queryParams
        dict["headers"] = dataSanitizer.sanitizeHeaders(headers: headers)
        dict["body"] = body
        return dict
    }
}
