import Foundation

/// The schema for an integration mapping mapped item object for type Teams.
public class IntegrationMappingPartnerItemTeams: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case tenantId = "tenant_id"
    }

    /// Type of the mapped item referenced in `id`
    public let type: IntegrationMappingPartnerItemTeamsTypeField

    /// ID of the mapped item (of type referenced in `type`)
    public let id: String

    /// ID of the tenant that is registered with Microsoft Teams.
    public let tenantId: String

    /// Initializer for a IntegrationMappingPartnerItemTeams.
    ///
    /// - Parameters:
    ///   - type: Type of the mapped item referenced in `id`
    ///   - id: ID of the mapped item (of type referenced in `type`)
    ///   - tenantId: ID of the tenant that is registered with Microsoft Teams.
    public init(type: IntegrationMappingPartnerItemTeamsTypeField, id: String, tenantId: String) {
        self.type = type
        self.id = id
        self.tenantId = tenantId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(IntegrationMappingPartnerItemTeamsTypeField.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
        tenantId = try container.decode(String.self, forKey: .tenantId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(tenantId, forKey: .tenantId)
    }

}
