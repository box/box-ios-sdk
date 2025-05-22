import Foundation

/// The bare basic representation of a file version, the minimal
/// amount of fields returned when using the `fields` query
/// parameter.
public class FileVersionBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier that represent a file version.
    public let id: String

    /// `file_version`
    public let type: FileVersionBaseTypeField

    /// Initializer for a FileVersionBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a file version.
    ///   - type: `file_version`
    public init(id: String, type: FileVersionBaseTypeField = FileVersionBaseTypeField.fileVersion) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(FileVersionBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
