import Foundation

public enum GroupMiniOrUserCollaborations: Codable {
    case groupMini(GroupMini)
    case userCollaborations(UserCollaborations)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "group":
                    if let content = try? GroupMini(from: decoder) {
                        self = .groupMini(content)
                        return
                    }

                case "user":
                    if let content = try? UserCollaborations(from: decoder) {
                        self = .userCollaborations(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(GroupMiniOrUserCollaborations.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(GroupMiniOrUserCollaborations.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .groupMini(let groupMini):
            try groupMini.encode(to: encoder)
        case .userCollaborations(let userCollaborations):
            try userCollaborations.encode(to: encoder)
        }
    }

}
