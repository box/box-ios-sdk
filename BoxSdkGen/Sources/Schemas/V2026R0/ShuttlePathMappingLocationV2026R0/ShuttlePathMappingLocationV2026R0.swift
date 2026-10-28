import Foundation

/// One side of a path mapping. The object shape is determined by `type`.
public enum ShuttlePathMappingLocationV2026R0: Codable {
    case shuttlePathMappingAccountLocationV2026R0(ShuttlePathMappingAccountLocationV2026R0)
    case shuttlePathMappingSharedSpaceLocationV2026R0(ShuttlePathMappingSharedSpaceLocationV2026R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "account":
                    if let content = try? ShuttlePathMappingAccountLocationV2026R0(from: decoder) {
                        self = .shuttlePathMappingAccountLocationV2026R0(content)
                        return
                    }

                case "shared_space":
                    if let content = try? ShuttlePathMappingSharedSpaceLocationV2026R0(from: decoder) {
                        self = .shuttlePathMappingSharedSpaceLocationV2026R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(ShuttlePathMappingLocationV2026R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .shuttlePathMappingAccountLocationV2026R0(let shuttlePathMappingAccountLocationV2026R0):
            try shuttlePathMappingAccountLocationV2026R0.encode(to: encoder)
        case .shuttlePathMappingSharedSpaceLocationV2026R0(let shuttlePathMappingSharedSpaceLocationV2026R0):
            try shuttlePathMappingSharedSpaceLocationV2026R0.encode(to: encoder)
        }
    }

}
