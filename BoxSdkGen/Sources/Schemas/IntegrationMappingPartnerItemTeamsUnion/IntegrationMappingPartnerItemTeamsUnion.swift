import Foundation

public enum IntegrationMappingPartnerItemTeamsUnion: Codable {
    case integrationMappingPartnerItemTeams(IntegrationMappingPartnerItemTeams)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "channel":
                    if let content = try? IntegrationMappingPartnerItemTeams(from: decoder) {
                        self = .integrationMappingPartnerItemTeams(content)
                        return
                    }

                case "team":
                    if let content = try? IntegrationMappingPartnerItemTeams(from: decoder) {
                        self = .integrationMappingPartnerItemTeams(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(IntegrationMappingPartnerItemTeamsUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(IntegrationMappingPartnerItemTeamsUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .integrationMappingPartnerItemTeams(let integrationMappingPartnerItemTeams):
            try integrationMappingPartnerItemTeams.encode(to: encoder)
        }
    }

}
