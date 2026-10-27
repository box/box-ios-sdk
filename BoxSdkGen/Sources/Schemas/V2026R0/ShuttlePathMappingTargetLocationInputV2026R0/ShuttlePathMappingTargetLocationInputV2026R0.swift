import Foundation

/// A destination location supplied when creating or updating a path mapping.
/// The object shape is determined by `type`. Destination input does not
/// include `is_directory`; that flag is taken from the source.
public enum ShuttlePathMappingTargetLocationInputV2026R0: Codable {
    case shuttlePathMappingAccountLocationTargetInputV2026R0(ShuttlePathMappingAccountLocationTargetInputV2026R0)
    case shuttlePathMappingSharedSpaceLocationTargetInputV2026R0(ShuttlePathMappingSharedSpaceLocationTargetInputV2026R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "account":
                    if let content = try? ShuttlePathMappingAccountLocationTargetInputV2026R0(from: decoder) {
                        self = .shuttlePathMappingAccountLocationTargetInputV2026R0(content)
                        return
                    }

                case "shared_space":
                    if let content = try? ShuttlePathMappingSharedSpaceLocationTargetInputV2026R0(from: decoder) {
                        self = .shuttlePathMappingSharedSpaceLocationTargetInputV2026R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(ShuttlePathMappingTargetLocationInputV2026R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .shuttlePathMappingAccountLocationTargetInputV2026R0(let shuttlePathMappingAccountLocationTargetInputV2026R0):
            try shuttlePathMappingAccountLocationTargetInputV2026R0.encode(to: encoder)
        case .shuttlePathMappingSharedSpaceLocationTargetInputV2026R0(let shuttlePathMappingSharedSpaceLocationTargetInputV2026R0):
            try shuttlePathMappingSharedSpaceLocationTargetInputV2026R0.encode(to: encoder)
        }
    }

}
