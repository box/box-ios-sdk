import Foundation

/// A mini legal hold policy
public class LegalHoldPolicyMini: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for this legal hold policy
    public let id: String

    /// `legal_hold_policy`
    public let type: LegalHoldPolicyMiniTypeField

    /// Initializer for a LegalHoldPolicyMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this legal hold policy
    ///   - type: `legal_hold_policy`
    public init(id: String, type: LegalHoldPolicyMiniTypeField = LegalHoldPolicyMiniTypeField.legalHoldPolicy) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(LegalHoldPolicyMiniTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
