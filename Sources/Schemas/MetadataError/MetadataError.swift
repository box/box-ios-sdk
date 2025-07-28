import Foundation

/// A generic metadata operation error.
public class MetadataError: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case code
        case message
        case requestId = "request_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A Box-specific error code.
    public let code: String?

    /// A short message describing the error.
    public let message: String?

    /// A unique identifier for this response, which can be used
    /// when contacting Box support.
    public let requestId: String?

    /// Initializer for a MetadataError.
    ///
    /// - Parameters:
    ///   - code: A Box-specific error code.
    ///   - message: A short message describing the error.
    ///   - requestId: A unique identifier for this response, which can be used
    ///     when contacting Box support.
    public init(code: String? = nil, message: String? = nil, requestId: String? = nil) {
        self.code = code
        self.message = message
        self.requestId = requestId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeIfPresent(String.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        requestId = try container.decodeIfPresent(String.self, forKey: .requestId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(requestId, forKey: .requestId)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
