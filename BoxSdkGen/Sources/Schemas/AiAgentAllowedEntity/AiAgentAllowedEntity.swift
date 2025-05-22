import Foundation

/// The entity with type and ID.
public enum AiAgentAllowedEntity: Codable {
    case userBase(UserBase)
    case groupBase(GroupBase)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "user":
                    if let content = try? UserBase(from: decoder) {
                        self = .userBase(content)
                        return
                    }

                case "group":
                    if let content = try? GroupBase(from: decoder) {
                        self = .groupBase(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(AiAgentAllowedEntity.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(AiAgentAllowedEntity.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .userBase(let userBase):
            try userBase.encode(to: encoder)
        case .groupBase(let groupBase):
            try groupBase.encode(to: encoder)
        }
    }

}
