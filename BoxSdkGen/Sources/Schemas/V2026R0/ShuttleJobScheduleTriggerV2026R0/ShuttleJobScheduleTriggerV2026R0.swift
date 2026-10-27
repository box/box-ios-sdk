import Foundation

/// When a shuttle job schedule should start a run. Exactly one trigger
/// variant is present, discriminated by `type`.
public enum ShuttleJobScheduleTriggerV2026R0: Codable {
    case shuttleJobScheduleTriggerByTimeV2026R0(ShuttleJobScheduleTriggerByTimeV2026R0)
    case shuttleJobScheduleTriggerByJobV2026R0(ShuttleJobScheduleTriggerByJobV2026R0)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "by_time":
                    if let content = try? ShuttleJobScheduleTriggerByTimeV2026R0(from: decoder) {
                        self = .shuttleJobScheduleTriggerByTimeV2026R0(content)
                        return
                    }

                case "by_job":
                    if let content = try? ShuttleJobScheduleTriggerByJobV2026R0(from: decoder) {
                        self = .shuttleJobScheduleTriggerByJobV2026R0(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(ShuttleJobScheduleTriggerV2026R0.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .shuttleJobScheduleTriggerByTimeV2026R0(let shuttleJobScheduleTriggerByTimeV2026R0):
            try shuttleJobScheduleTriggerByTimeV2026R0.encode(to: encoder)
        case .shuttleJobScheduleTriggerByJobV2026R0(let shuttleJobScheduleTriggerByJobV2026R0):
            try shuttleJobScheduleTriggerByJobV2026R0.encode(to: encoder)
        }
    }

}
