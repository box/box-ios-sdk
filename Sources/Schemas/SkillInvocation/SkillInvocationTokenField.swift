import Foundation

public class SkillInvocationTokenField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case read
        case write
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The basics of an access token.
    public let read: SkillInvocationTokenReadField?

    /// The basics of an access token.
    public let write: SkillInvocationTokenWriteField?

    /// Initializer for a SkillInvocationTokenField.
    ///
    /// - Parameters:
    ///   - read: The basics of an access token.
    ///   - write: The basics of an access token.
    public init(read: SkillInvocationTokenReadField? = nil, write: SkillInvocationTokenWriteField? = nil) {
        self.read = read
        self.write = write
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        read = try container.decodeIfPresent(SkillInvocationTokenReadField.self, forKey: .read)
        write = try container.decodeIfPresent(SkillInvocationTokenWriteField.self, forKey: .write)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(read, forKey: .read)
        try container.encodeIfPresent(write, forKey: .write)
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
