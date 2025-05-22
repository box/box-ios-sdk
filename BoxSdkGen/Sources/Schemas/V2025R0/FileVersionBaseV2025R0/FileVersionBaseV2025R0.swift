import Foundation

/// The bare basic representation of a file version, the minimal
/// amount of fields returned when using the `fields` query
/// parameter.
public class FileVersionBaseV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier that represent a file version.
    public let id: String

    /// `file_version`
    public let type: FileVersionBaseV2025R0TypeField

    /// Initializer for a FileVersionBaseV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a file version.
    ///   - type: `file_version`
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

}
