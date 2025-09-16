import Foundation

/// Representation of content of a Shield List.
public enum ShieldListContentV2025R0: Codable {
    case shieldListContentCountryV2025R0(ShieldListContentCountryV2025R0)
    case shieldListContentDomainV2025R0(ShieldListContentDomainV2025R0)
    case shieldListContentEmailV2025R0(ShieldListContentEmailV2025R0)
    case shieldListContentIpV2025R0(ShieldListContentIpV2025R0)
    case shieldListContentIntegrationV2025R0(ShieldListContentIntegrationV2025R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "country":
                    if let content = try? ShieldListContentCountryV2025R0(from: decoder) {
                        self = .shieldListContentCountryV2025R0(content)
                        return
                    }

                case "domain":
                    if let content = try? ShieldListContentDomainV2025R0(from: decoder) {
                        self = .shieldListContentDomainV2025R0(content)
                        return
                    }

                case "email":
                    if let content = try? ShieldListContentEmailV2025R0(from: decoder) {
                        self = .shieldListContentEmailV2025R0(content)
                        return
                    }

                case "ip":
                    if let content = try? ShieldListContentIpV2025R0(from: decoder) {
                        self = .shieldListContentIpV2025R0(content)
                        return
                    }

                case "integration":
                    if let content = try? ShieldListContentIntegrationV2025R0(from: decoder) {
                        self = .shieldListContentIntegrationV2025R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(ShieldListContentV2025R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .shieldListContentCountryV2025R0(let shieldListContentCountryV2025R0):
            try shieldListContentCountryV2025R0.encode(to: encoder)
        case .shieldListContentDomainV2025R0(let shieldListContentDomainV2025R0):
            try shieldListContentDomainV2025R0.encode(to: encoder)
        case .shieldListContentEmailV2025R0(let shieldListContentEmailV2025R0):
            try shieldListContentEmailV2025R0.encode(to: encoder)
        case .shieldListContentIpV2025R0(let shieldListContentIpV2025R0):
            try shieldListContentIpV2025R0.encode(to: encoder)
        case .shieldListContentIntegrationV2025R0(let shieldListContentIntegrationV2025R0):
            try shieldListContentIntegrationV2025R0.encode(to: encoder)
        }
    }

}
