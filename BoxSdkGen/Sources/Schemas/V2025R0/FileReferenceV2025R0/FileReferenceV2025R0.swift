import Foundation

/// File reference
public class FileReferenceV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// ID of the object
    public let id: String

    /// `file`
    public let type: FileReferenceV2025R0TypeField

    /// Initializer for a FileReferenceV2025R0.
    ///
    /// - Parameters:
    ///   - id: ID of the object
    ///   - type: `file`
    public init(id: String, type: FileReferenceV2025R0TypeField = FileReferenceV2025R0TypeField.file) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(FileReferenceV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
