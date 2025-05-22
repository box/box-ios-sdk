import Foundation

public enum IntegrationMappingPartnerItemSlackUnion: Codable {
    case integrationMappingPartnerItemSlack(IntegrationMappingPartnerItemSlack)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "channel":
                    if let content = try? IntegrationMappingPartnerItemSlack(from: decoder) {
                        self = .integrationMappingPartnerItemSlack(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(IntegrationMappingPartnerItemSlackUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(IntegrationMappingPartnerItemSlackUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .integrationMappingPartnerItemSlack(let integrationMappingPartnerItemSlack):
            try integrationMappingPartnerItemSlack.encode(to: encoder)
        }
    }

}
