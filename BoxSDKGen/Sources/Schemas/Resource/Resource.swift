import Foundation

/// The file or folder resource.
public enum Resource: Codable {
    case folderMini(FolderMini)
    case fileMini(FileMini)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "folder":
                    if let content = try? FolderMini(from: decoder) {
                        self = .folderMini(content)
                        return
                    }

                case "file":
                    if let content = try? FileMini(from: decoder) {
                        self = .fileMini(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(Resource.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .folderMini(let folderMini):
            try folderMini.encode(to: encoder)
        case .fileMini(let fileMini):
            try fileMini.encode(to: encoder)
        }
    }

}
