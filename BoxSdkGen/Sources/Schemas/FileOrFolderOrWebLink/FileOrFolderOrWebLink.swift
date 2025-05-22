import Foundation

public enum FileOrFolderOrWebLink: Codable {
    case file(File)
    case folder(Folder)
    case webLink(WebLink)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "file":
                    if let content = try? File(from: decoder) {
                        self = .file(content)
                        return
                    }

                case "folder":
                    if let content = try? Folder(from: decoder) {
                        self = .folder(content)
                        return
                    }

                case "web_link":
                    if let content = try? WebLink(from: decoder) {
                        self = .webLink(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(FileOrFolderOrWebLink.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(FileOrFolderOrWebLink.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .file(let file):
            try file.encode(to: encoder)
        case .folder(let folder):
            try folder.encode(to: encoder)
        case .webLink(let webLink):
            try webLink.encode(to: encoder)
        }
    }

}
