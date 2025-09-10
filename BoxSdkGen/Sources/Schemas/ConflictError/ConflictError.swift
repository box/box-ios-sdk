import Foundation

/// The error that occurs when a file can not be created due
/// to a conflict.
public class ConflictError: ClientError {
    private enum CodingKeys: CodingKey {
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// Initializer for a ConflictError.
    ///
    /// - Parameters:
    ///   - type: The value will always be `error`.
    ///   - status: The HTTP status of the response.
    ///   - code: A Box-specific error code.
    ///   - message: A short message describing the error.
    ///   - contextInfo: A free-form object that contains additional context
    ///     about the error. The possible fields are defined on
    ///     a per-endpoint basis. `message` is only one example.
    ///   - helpUrl: A URL that links to more information about why this error occurred.
    ///   - requestId: A unique identifier for this response, which can be used
    ///     when contacting Box support.
    public override init(type: ClientErrorTypeField? = nil, status: Int? = nil, code: ClientErrorCodeField? = nil, message: String? = nil, contextInfo: TriStateField<[String: AnyCodable]> = nil, helpUrl: String? = nil, requestId: String? = nil) {
        super.init(type: type, status: status, code: code, message: message, contextInfo: contextInfo, helpUrl: helpUrl, requestId: requestId)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
