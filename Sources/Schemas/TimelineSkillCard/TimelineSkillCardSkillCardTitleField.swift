import Foundation

public class TimelineSkillCardSkillCardTitleField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case message
        case code
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The actual title to show in the UI.
    public let message: String

    /// An optional identifier for the title.
    public let code: String?

    /// Initializer for a TimelineSkillCardSkillCardTitleField.
    ///
    /// - Parameters:
    ///   - message: The actual title to show in the UI.
    ///   - code: An optional identifier for the title.
    public init(message: String, code: String? = nil) {
        self.message = message
        self.code = code
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        code = try container.decodeIfPresent(String.self, forKey: .code)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encodeIfPresent(code, forKey: .code)
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
