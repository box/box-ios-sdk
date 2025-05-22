import Foundation

public enum FileBaseOrFolderBaseOrWebLinkBase: Codable {
    case fileBase(FileBase)
    case folderBase(FolderBase)
    case webLinkBase(WebLinkBase)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "file":
                    if let content = try? FileBase(from: decoder) {
                        self = .fileBase(content)
                        return
                    }

                case "folder":
                    if let content = try? FolderBase(from: decoder) {
                        self = .folderBase(content)
                        return
                    }

                case "web_link":
                    if let content = try? WebLinkBase(from: decoder) {
                        self = .webLinkBase(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(FileBaseOrFolderBaseOrWebLinkBase.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(FileBaseOrFolderBaseOrWebLinkBase.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .fileBase(let fileBase):
            try fileBase.encode(to: encoder)
        case .folderBase(let folderBase):
            try folderBase.encode(to: encoder)
        case .webLinkBase(let webLinkBase):
            try webLinkBase.encode(to: encoder)
        }
    }

}
