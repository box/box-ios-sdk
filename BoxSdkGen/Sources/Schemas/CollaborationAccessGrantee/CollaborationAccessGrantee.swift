import Foundation

/// The user or group that is granted access.
public enum CollaborationAccessGrantee: Codable {
    case userCollaborations(UserCollaborations)
    case groupMini(GroupMini)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "user":
                    if let content = try? UserCollaborations(from: decoder) {
                        self = .userCollaborations(content)
                        return
                    }

                case "group":
                    if let content = try? GroupMini(from: decoder) {
                        self = .groupMini(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(CollaborationAccessGrantee.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .userCollaborations(let userCollaborations):
            try userCollaborations.encode(to: encoder)
        case .groupMini(let groupMini):
            try groupMini.encode(to: encoder)
        }
    }

}
