import Foundation

public enum FileMiniOrFolderMini: Codable {
    case fileMini(FileMini)
    case folderMini(FolderMini)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "file":
                    if let content = try? FileMini(from: decoder) {
                        self = .fileMini(content)
                        return
                    }

                case "folder":
                    if let content = try? FolderMini(from: decoder) {
                        self = .folderMini(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(FileMiniOrFolderMini.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(FileMiniOrFolderMini.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .fileMini(let fileMini):
            try fileMini.encode(to: encoder)
        case .folderMini(let folderMini):
            try folderMini.encode(to: encoder)
        }
    }

}
