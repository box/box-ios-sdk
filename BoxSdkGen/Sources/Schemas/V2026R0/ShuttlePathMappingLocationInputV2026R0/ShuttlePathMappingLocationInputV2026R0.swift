import Foundation

/// A source location supplied when creating or updating a path mapping. The
/// object shape is determined by `type`.
public enum ShuttlePathMappingLocationInputV2026R0: Codable {
    case shuttlePathMappingAccountLocationInputV2026R0(ShuttlePathMappingAccountLocationInputV2026R0)
    case shuttlePathMappingSharedSpaceLocationInputV2026R0(ShuttlePathMappingSharedSpaceLocationInputV2026R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "account":
                    if let content = try? ShuttlePathMappingAccountLocationInputV2026R0(from: decoder) {
                        self = .shuttlePathMappingAccountLocationInputV2026R0(content)
                        return
                    }

                case "shared_space":
                    if let content = try? ShuttlePathMappingSharedSpaceLocationInputV2026R0(from: decoder) {
                        self = .shuttlePathMappingSharedSpaceLocationInputV2026R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(ShuttlePathMappingLocationInputV2026R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .shuttlePathMappingAccountLocationInputV2026R0(let shuttlePathMappingAccountLocationInputV2026R0):
            try shuttlePathMappingAccountLocationInputV2026R0.encode(to: encoder)
        case .shuttlePathMappingSharedSpaceLocationInputV2026R0(let shuttlePathMappingSharedSpaceLocationInputV2026R0):
            try shuttlePathMappingSharedSpaceLocationInputV2026R0.encode(to: encoder)
        }
    }

}
