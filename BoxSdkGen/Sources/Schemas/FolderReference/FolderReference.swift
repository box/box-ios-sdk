import Foundation

/// Folder reference
public class FolderReference: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// ID of the folder
    public let id: String

    /// `folder`
    public let type: FolderReferenceTypeField

    /// Initializer for a FolderReference.
    ///
    /// - Parameters:
    ///   - id: ID of the folder
    ///   - type: `folder`
    public init(id: String, type: FolderReferenceTypeField = FolderReferenceTypeField.folder) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(FolderReferenceTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
