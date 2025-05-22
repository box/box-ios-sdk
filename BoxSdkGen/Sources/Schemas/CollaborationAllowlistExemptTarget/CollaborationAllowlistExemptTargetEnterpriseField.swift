import Foundation

public class CollaborationAllowlistExemptTargetEnterpriseField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
    }

    /// The unique identifier for this enterprise.
    public let id: String?

    /// `enterprise`
    public let type: CollaborationAllowlistExemptTargetEnterpriseTypeField?

    /// The name of the enterprise
    public let name: String?

    /// Initializer for a CollaborationAllowlistExemptTargetEnterpriseField.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this enterprise.
    ///   - type: `enterprise`
    ///   - name: The name of the enterprise
    public init(id: String? = nil, type: CollaborationAllowlistExemptTargetEnterpriseTypeField? = nil, name: String? = nil) {
        self.id = id
        self.type = type
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(CollaborationAllowlistExemptTargetEnterpriseTypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
    }

}
