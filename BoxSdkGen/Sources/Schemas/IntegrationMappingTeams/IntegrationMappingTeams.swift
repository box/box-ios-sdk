import Foundation

/// A Microsoft Teams specific representation of an integration
/// mapping object.
public class IntegrationMappingTeams: IntegrationMappingBase {
    private enum CodingKeys: String, CodingKey {
        case partnerItem = "partner_item"
        case boxItem = "box_item"
        case integrationType = "integration_type"
        case isOverriddenByManualMapping = "is_overridden_by_manual_mapping"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

    /// Mapped item object for Teams
    public let partnerItem: IntegrationMappingPartnerItemTeamsUnion

    public let boxItem: FolderReference

    /// Identifies the Box partner app,
    /// with which the mapping is associated.
    /// Supports Slack and Teams.
    /// (part of the composite key together with `id`)
    public let integrationType: IntegrationMappingTeamsIntegrationTypeField?

    /// Identifies whether the mapping has
    /// been manually set by the team owner from UI for channels
    /// (as opposed to being automatically created)
    public let isOverriddenByManualMapping: Bool?

    /// When the integration mapping object was created
    public let createdAt: Date?

    /// When the integration mapping object was last modified
    public let modifiedAt: Date?

    /// Initializer for a IntegrationMappingTeams.
    ///
    /// - Parameters:
    ///   - id: A unique identifier of a folder mapping
    ///     (part of a composite key together
    ///     with `integration_type`)
    ///   - partnerItem: Mapped item object for Teams
    ///   - boxItem: 
    ///   - type: Mapping type
    ///   - integrationType: Identifies the Box partner app,
    ///     with which the mapping is associated.
    ///     Supports Slack and Teams.
    ///     (part of the composite key together with `id`)
    ///   - isOverriddenByManualMapping: Identifies whether the mapping has
    ///     been manually set by the team owner from UI for channels
    ///     (as opposed to being automatically created)
    ///   - createdAt: When the integration mapping object was created
    ///   - modifiedAt: When the integration mapping object was last modified
    public init(id: String, partnerItem: IntegrationMappingPartnerItemTeamsUnion, boxItem: FolderReference, type: IntegrationMappingBaseTypeField = IntegrationMappingBaseTypeField.integrationMapping, integrationType: IntegrationMappingTeamsIntegrationTypeField? = nil, isOverriddenByManualMapping: Bool? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil) {
        self.partnerItem = partnerItem
        self.boxItem = boxItem
        self.integrationType = integrationType
        self.isOverriddenByManualMapping = isOverriddenByManualMapping
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        partnerItem = try container.decode(IntegrationMappingPartnerItemTeamsUnion.self, forKey: .partnerItem)
        boxItem = try container.decode(FolderReference.self, forKey: .boxItem)
        integrationType = try container.decodeIfPresent(IntegrationMappingTeamsIntegrationTypeField.self, forKey: .integrationType)
        isOverriddenByManualMapping = try container.decodeIfPresent(Bool.self, forKey: .isOverriddenByManualMapping)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(partnerItem, forKey: .partnerItem)
        try container.encode(boxItem, forKey: .boxItem)
        try container.encodeIfPresent(integrationType, forKey: .integrationType)
        try container.encodeIfPresent(isOverriddenByManualMapping, forKey: .isOverriddenByManualMapping)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try super.encode(to: encoder)
    }

}
