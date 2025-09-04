import Foundation

/// Reference to an item that can be added to a Box Hub.
public enum HubItemReferenceV2025R0: Codable {
    case fileReferenceV2025R0(FileReferenceV2025R0)
    case folderReferenceV2025R0(FolderReferenceV2025R0)
    case weblinkReferenceV2025R0(WeblinkReferenceV2025R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "file":
                    if let content = try? FileReferenceV2025R0(from: decoder) {
                        self = .fileReferenceV2025R0(content)
                        return
                    }

                case "folder":
                    if let content = try? FolderReferenceV2025R0(from: decoder) {
                        self = .folderReferenceV2025R0(content)
                        return
                    }

                case "weblink":
                    if let content = try? WeblinkReferenceV2025R0(from: decoder) {
                        self = .weblinkReferenceV2025R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(HubItemReferenceV2025R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .fileReferenceV2025R0(let fileReferenceV2025R0):
            try fileReferenceV2025R0.encode(to: encoder)
        case .folderReferenceV2025R0(let folderReferenceV2025R0):
            try folderReferenceV2025R0.encode(to: encoder)
        case .weblinkReferenceV2025R0(let weblinkReferenceV2025R0):
            try weblinkReferenceV2025R0.encode(to: encoder)
        }
    }

}
