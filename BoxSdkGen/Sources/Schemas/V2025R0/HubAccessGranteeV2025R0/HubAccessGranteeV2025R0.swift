import Foundation

/// The user or group that is granted access.
public enum HubAccessGranteeV2025R0: Codable {
    case hubCollaborationUserV2025R0(HubCollaborationUserV2025R0)
    case groupMiniV2025R0(GroupMiniV2025R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "user":
                    if let content = try? HubCollaborationUserV2025R0(from: decoder) {
                        self = .hubCollaborationUserV2025R0(content)
                        return
                    }

                case "group":
                    if let content = try? GroupMiniV2025R0(from: decoder) {
                        self = .groupMiniV2025R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(HubAccessGranteeV2025R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .hubCollaborationUserV2025R0(let hubCollaborationUserV2025R0):
            try hubCollaborationUserV2025R0.encode(to: encoder)
        case .groupMiniV2025R0(let groupMiniV2025R0):
            try groupMiniV2025R0.encode(to: encoder)
        }
    }

}
