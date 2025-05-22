import Foundation

/// A generic error
public class ClientError: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case status
        case code
        case message
        case contextInfo = "context_info"
        case helpUrl = "help_url"
        case requestId = "request_id"
    }

    /// error
    public let type: ClientErrorTypeField?

    /// The HTTP status of the response.
    public let status: Int?

    /// A Box-specific error code
    public let code: ClientErrorCodeField?

    /// A short message describing the error.
    public let message: String?

    /// A free-form object that contains additional context
    /// about the error. The possible fields are defined on
    /// a per-endpoint basis. `message` is only one example.
    @CodableTriState public private(set) var contextInfo: [String: AnyCodable]?

    /// A URL that links to more information about why this error occurred.
    public let helpUrl: String?

    /// A unique identifier for this response, which can be used
    /// when contacting Box support.
    public let requestId: String?

    /// Initializer for a ClientError.
    ///
    /// - Parameters:
    ///   - type: error
    ///   - status: The HTTP status of the response.
    ///   - code: A Box-specific error code
    ///   - message: A short message describing the error.
    ///   - contextInfo: A free-form object that contains additional context
    ///     about the error. The possible fields are defined on
    ///     a per-endpoint basis. `message` is only one example.
    ///   - helpUrl: A URL that links to more information about why this error occurred.
    ///   - requestId: A unique identifier for this response, which can be used
    ///     when contacting Box support.
    public init(type: ClientErrorTypeField? = nil, status: Int? = nil, code: ClientErrorCodeField? = nil, message: String? = nil, contextInfo: TriStateField<[String: AnyCodable]> = nil, helpUrl: String? = nil, requestId: String? = nil) {
        self.type = type
        self.status = status
        self.code = code
        self.message = message
        self._contextInfo = CodableTriState(state: contextInfo)
        self.helpUrl = helpUrl
        self.requestId = requestId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(ClientErrorTypeField.self, forKey: .type)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        code = try container.decodeIfPresent(ClientErrorCodeField.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        contextInfo = try container.decodeIfPresent([String: AnyCodable].self, forKey: .contextInfo)
        helpUrl = try container.decodeIfPresent(String.self, forKey: .helpUrl)
        requestId = try container.decodeIfPresent(String.self, forKey: .requestId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encode(field: _contextInfo.state, forKey: .contextInfo)
        try container.encodeIfPresent(helpUrl, forKey: .helpUrl)
        try container.encodeIfPresent(requestId, forKey: .requestId)
    }

}
