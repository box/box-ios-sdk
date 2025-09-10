import Foundation

/// The mini representation of a file or folder.
public enum MetadataQueryResultItem: Codable {
    case fileFull(FileFull)
    case folderFull(FolderFull)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "file":
                    if let content = try? FileFull(from: decoder) {
                        self = .fileFull(content)
                        return
                    }

                case "folder":
                    if let content = try? FolderFull(from: decoder) {
                        self = .folderFull(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(MetadataQueryResultItem.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .fileFull(let fileFull):
            try fileFull.encode(to: encoder)
        case .folderFull(let folderFull):
            try folderFull.encode(to: encoder)
        }
    }

}
