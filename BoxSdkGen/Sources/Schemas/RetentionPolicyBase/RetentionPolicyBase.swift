import Foundation

/// A base representation of a retention policy.
public class RetentionPolicyBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier that represents a retention policy.
    public let id: String

    /// `retention_policy`
    public let type: RetentionPolicyBaseTypeField

    /// Initializer for a RetentionPolicyBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represents a retention policy.
    ///   - type: `retention_policy`
    public init(id: String, type: RetentionPolicyBaseTypeField = RetentionPolicyBaseTypeField.retentionPolicy) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(RetentionPolicyBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
