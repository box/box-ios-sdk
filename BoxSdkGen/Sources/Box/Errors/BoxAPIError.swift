import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Describes API request related errors.
public class BoxAPIError: BoxSDKError {
    /// The request information
    public let requestInfo: RequestInfo
    /// The response information
    public let responseInfo: ResponseInfo

    public let dataSanitizer: DataSanitizer
    /// Initializer
    ///
    /// - Parameters:
    ///   - message: The error message
    ///   - requestInfo: The request information
    ///   - responseInfo: The response information
    ///   - timestamp: The timestamp of the error
    ///   - error: The underlying error which caused this error, if any.
    public init(message: String, requestInfo: RequestInfo, responseInfo: ResponseInfo, timestamp: Date? = nil, error: Error? = nil, dataSanitizer: DataSanitizer = DataSanitizer()) {
        self.requestInfo = requestInfo
        self.responseInfo = responseInfo
        self.dataSanitizer = dataSanitizer

        super.init(message: message, timestamp: timestamp, error: error, name: "BoxAPIError")
    }

    /// Gets a dictionary representing the APIError.
    ///
    /// - Returns: A dictionary representing the APIError.
    override public func getDictionary() -> [String: Any] {
        var dict = super.getDictionary()
        dict["request"] = requestInfo.getDictionary(dataSanitizer: self.dataSanitizer)
        dict["response"] = responseInfo.getDictionary(dataSanitizer: self.dataSanitizer)
        return dict
    }

}

extension BoxAPIError {
    /// Initializer
    ///
    /// - Parameters:
    ///   - fromConversation: Represents a data combined with the request and the corresponding response.
    convenience init(fromConversation conversation: FetchConversation, message: String? = nil) {
        let requestHeaders = conversation.options.headers ?? [:]
        let requestInfo = RequestInfo(
            method: conversation.options.method.uppercased(),
            url: conversation.options.url,
            queryParams: conversation.options.params ?? [:],
            headers:  requestHeaders,
            body:  requestHeaders[HTTPHeaderKey.contentType, default: ""].paramValue == HTTPHeaderContentTypeValue.urlEncoded
            ? try? conversation.options.data?.toUrlParams()
            : try? Utils.Strings.from(data: conversation.options.data?.toJson() ?? Data())
        )

        var body: SerializedData?
        var json: [String: Any]?
        if case let .data(data) = conversation.responseType {
            body = SerializedData(data: data)
            json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        let responseInfo = ResponseInfo(
            statusCode: conversation.urlResponse.statusCode,
            headers: conversation.urlResponse.allHeaderFields as? [String: String] ?? [:],
            body: body,
            rawBody:  try? Utils.Strings.from(data: body?.toJson() ?? Data()),
            code: json?["code"] as? String,
            contextInfo: json?["context_info"] as? [String: Any],
            requestId: json?["request_id"] as? String,
            helperUrl: json?["help_url"] as? String,
            message: json?["message"] as? String
        )

        self.init(
            message: message ?? Self.createMessage(fromResponse: responseInfo),
            requestInfo: requestInfo,
            responseInfo: responseInfo,
            dataSanitizer: conversation.options.networkSession?.dataSanitizer ?? DataSanitizer()
        )
    }

    /// Gets a formatted user-friendly message based on the `ResponseDescription`
    ///
    /// - Returns: Formatted user-friendly message based on the `ResponseDescription`
    static func createMessage(fromResponse response: ResponseInfo) -> String {
        var message = "The API returned an unexpected response: "
        message += "[\(response.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode).capitalized)"

        if let requestId = response.requestId {
            message += " | \(requestId)] "
        }
        else {
            message += "]"
        }

        if let code = response.code {
            message += " \(code)"
        }

        if let shortMessage = response.message {
            message += " - \(shortMessage)"
        }

        return message
    }
}
