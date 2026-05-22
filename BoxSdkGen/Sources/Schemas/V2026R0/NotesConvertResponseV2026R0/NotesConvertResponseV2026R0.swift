import Foundation

/// Identifies the created Box Note file.
public class NotesConvertResponseV2026R0: Codable, RawJSONReadable {
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


    /// Box file ID of the created `.boxnote` file.
    public let id: String

    /// The Box resource type; always `file` for a Box file.
    public let type: NotesConvertResponseV2026R0TypeField

    /// Initializer for a NotesConvertResponseV2026R0.
    ///
    /// - Parameters:
    ///   - id: Box file ID of the created `.boxnote` file.
    ///   - type: The Box resource type; always `file` for a Box file.
    public init(id: String, type: NotesConvertResponseV2026R0TypeField = NotesConvertResponseV2026R0TypeField.file) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(NotesConvertResponseV2026R0TypeField.self, forKey: .type)
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
