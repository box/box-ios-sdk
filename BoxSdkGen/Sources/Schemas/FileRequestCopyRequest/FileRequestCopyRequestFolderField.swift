import Foundation

public class FileRequestCopyRequestFolderField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID of the folder to associate the new
    /// file request to.
    public let id: String

    /// `folder`
    public let type: FileRequestCopyRequestFolderTypeField?

    /// Initializer for a FileRequestCopyRequestFolderField.
    ///
    /// - Parameters:
    ///   - id: The ID of the folder to associate the new
    ///     file request to.
    ///   - type: `folder`
    public init(id: String, type: FileRequestCopyRequestFolderTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decodeIfPresent(FileRequestCopyRequestFolderTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
