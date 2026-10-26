import Foundation

/// Which mapping namespace this path entry belongs to. Discriminated by
/// `type`: `account` flattens the owning account onto the object;
/// `shared_space` carries the shared container name. File versus folder
/// is not part of scope. Use `is_directory` on the path entry.
public enum ShuttlePathEntryScopeV2026R0: Codable {
    case shuttlePathEntryAccountScopeV2026R0(ShuttlePathEntryAccountScopeV2026R0)
    case shuttlePathEntrySharedSpaceScopeV2026R0(ShuttlePathEntrySharedSpaceScopeV2026R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "account":
                    if let content = try? ShuttlePathEntryAccountScopeV2026R0(from: decoder) {
                        self = .shuttlePathEntryAccountScopeV2026R0(content)
                        return
                    }

                case "shared_space":
                    if let content = try? ShuttlePathEntrySharedSpaceScopeV2026R0(from: decoder) {
                        self = .shuttlePathEntrySharedSpaceScopeV2026R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(ShuttlePathEntryScopeV2026R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .shuttlePathEntryAccountScopeV2026R0(let shuttlePathEntryAccountScopeV2026R0):
            try shuttlePathEntryAccountScopeV2026R0.encode(to: encoder)
        case .shuttlePathEntrySharedSpaceScopeV2026R0(let shuttlePathEntrySharedSpaceScopeV2026R0):
            try shuttlePathEntrySharedSpaceScopeV2026R0.encode(to: encoder)
        }
    }

}
