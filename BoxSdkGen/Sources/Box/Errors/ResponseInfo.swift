import Foundation

/// The class that represents the response information.
public class ResponseInfo {
    /// The HTTP status code of the response
    public let statusCode: Int
    /// The HTTP headers of the response
    public let headers: [String: String]
    /// The response body
    public let body: SerializedData?
    /// The string representation of the response body
    public let rawBody: String?
    ///A Box-specific error code
    public let code: String?
    /// A free-form object that contains additional context about the error
    public let contextInfo: [String: Any]?
    /// A unique identifier for this response, which can be used when contacting Box support
    public let requestId: String?
    /// A URL that links to more information about why this error occurred
    public let helpUrl: String?
    /// A short message describing the error
    public let message: String?


    /// Initializer
    ///
    /// - Parameters:
    ///   - statusCode: The HTTP status code of the response
    ///   - headers: The HTTP headers of the response
    ///   - body: The response body
    ///   - rawBody: The string representation of the response body
    ///   - code: A free-form object that contains additional context about the error
    ///   - contextInfo: A free-form object that contains additional context about the error
    ///   - requestId: A unique identifier for this response, which can be used when contacting Box support
    ///   - helpUrl: A URL that links to more information about why this error occurred
    ///   - message: A short message describing the error
    public init(statusCode: Int, headers: [String: String], body: SerializedData? = nil, rawBody: String? = nil, code: String? = nil, contextInfo: [String: Any]? = nil, requestId: String? = nil, helperUrl: String? = nil, message: String? = nil) {
        self.statusCode = statusCode
        self.headers = headers
        self.body = body
        self.rawBody = rawBody
        self.code = code
        self.contextInfo = contextInfo
        self.requestId = requestId
        self.helpUrl = helperUrl
        self.message = message
    }

}

extension ResponseInfo {
    /// Get a dictionary representing a `ResponseInfo`.
    ///
    /// - Returns: A dictionary representing a `ResponseInfo`.
    func getDictionary(dataSanitizer: DataSanitizer) -> [String: Any] {
        var dict = [String: Any]()
        dict["statusCode"] = statusCode
        dict["headers"] = dataSanitizer.sanitizeHeaders(headers: headers)
        dict["rawBody"] = rawBody
        dict["code"] = code
        dict["contextInfo"] = contextInfo
        dict["requestId"] = requestId
        dict["helpUrl"] = helpUrl
        dict["message"] = message
        return dict
    }
}
