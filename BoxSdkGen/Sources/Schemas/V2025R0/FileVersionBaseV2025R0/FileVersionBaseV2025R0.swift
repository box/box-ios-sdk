import Foundation

/// The bare basic representation of a file version, the minimal
/// amount of fields returned when using the `fields` query
/// parameter.
public class FileVersionBaseV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier that represent a file version.
    public let id: String

    /// The value will always be `file_version`.
    public let type: FileVersionBaseV2025R0TypeField

    /// Initializer for a FileVersionBaseV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a file version.
    ///   - type: The value will always be `file_version`.
    public init(id: String, type: FileVersionBaseV2025R0TypeField = FileVersionBaseV2025R0TypeField.fileVersion) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(FileVersionBaseV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
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
