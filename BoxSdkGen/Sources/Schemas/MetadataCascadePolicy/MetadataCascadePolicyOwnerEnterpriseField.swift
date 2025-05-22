import Foundation

public class MetadataCascadePolicyOwnerEnterpriseField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// `enterprise`
    public let type: MetadataCascadePolicyOwnerEnterpriseTypeField?

    /// The ID of the enterprise that owns the policy.
    public let id: String?

    /// Initializer for a MetadataCascadePolicyOwnerEnterpriseField.
    ///
    /// - Parameters:
    ///   - type: `enterprise`
    ///   - id: The ID of the enterprise that owns the policy.
    public init(type: MetadataCascadePolicyOwnerEnterpriseTypeField? = nil, id: String? = nil) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(MetadataCascadePolicyOwnerEnterpriseTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
    }

}
