import Foundation

/// A Slack specific representation of an integration
/// mapping object.
public class IntegrationMapping: IntegrationMappingBase {
    private enum CodingKeys: String, CodingKey {
        case partnerItem = "partner_item"
        case boxItem = "box_item"
        case integrationType = "integration_type"
        case isManuallyCreated = "is_manually_created"
        case options
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

    /// Mapped item object for Slack
    public let partnerItem: IntegrationMappingPartnerItemSlackUnion

    /// The Box folder, to which the object from the
    /// partner app domain (referenced in `partner_item_id`) is mapped
    public let boxItem: FolderMini

    /// Identifies the Box partner app,
    /// with which the mapping is associated.
    /// Currently only supports Slack.
    /// (part of the composite key together with `id`)
    public let integrationType: IntegrationMappingIntegrationTypeField?

    /// Identifies whether the mapping has
    /// been manually set
    /// (as opposed to being automatically created)
    public let isManuallyCreated: Bool?

    public let options: IntegrationMappingSlackOptions?

    /// An object representing the user who
    /// created the integration mapping
    public let createdBy: UserIntegrationMappings?

    /// The user who
    /// last modified the integration mapping
    public let modifiedBy: UserIntegrationMappings?

    /// When the integration mapping object was created
    public let createdAt: Date?

    /// When the integration mapping object was last modified
    public let modifiedAt: Date?

    /// Initializer for a IntegrationMapping.
    ///
    /// - Parameters:
    ///   - id: A unique identifier of a folder mapping
    ///     (part of a composite key together
    ///     with `integration_type`)
    ///   - partnerItem: Mapped item object for Slack
    ///   - boxItem: The Box folder, to which the object from the
    ///     partner app domain (referenced in `partner_item_id`) is mapped
    ///   - type: Mapping type
    ///   - integrationType: Identifies the Box partner app,
    ///     with which the mapping is associated.
    ///     Currently only supports Slack.
    ///     (part of the composite key together with `id`)
    ///   - isManuallyCreated: Identifies whether the mapping has
    ///     been manually set
    ///     (as opposed to being automatically created)
    ///   - options: 
    ///   - createdBy: An object representing the user who
    ///     created the integration mapping
    ///   - modifiedBy: The user who
    ///     last modified the integration mapping
    ///   - createdAt: When the integration mapping object was created
    ///   - modifiedAt: When the integration mapping object was last modified
    public init(id: String, partnerItem: IntegrationMappingPartnerItemSlackUnion, boxItem: FolderMini, type: IntegrationMappingBaseTypeField = IntegrationMappingBaseTypeField.integrationMapping, integrationType: IntegrationMappingIntegrationTypeField? = nil, isManuallyCreated: Bool? = nil, options: IntegrationMappingSlackOptions? = nil, createdBy: UserIntegrationMappings? = nil, modifiedBy: UserIntegrationMappings? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil) {
        self.partnerItem = partnerItem
        self.boxItem = boxItem
        self.integrationType = integrationType
        self.isManuallyCreated = isManuallyCreated
        self.options = options
        self.createdBy = createdBy
        self.modifiedBy = modifiedBy
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        partnerItem = try container.decode(IntegrationMappingPartnerItemSlackUnion.self, forKey: .partnerItem)
        boxItem = try container.decode(FolderMini.self, forKey: .boxItem)
        integrationType = try container.decodeIfPresent(IntegrationMappingIntegrationTypeField.self, forKey: .integrationType)
        isManuallyCreated = try container.decodeIfPresent(Bool.self, forKey: .isManuallyCreated)
        options = try container.decodeIfPresent(IntegrationMappingSlackOptions.self, forKey: .options)
        createdBy = try container.decodeIfPresent(UserIntegrationMappings.self, forKey: .createdBy)
        modifiedBy = try container.decodeIfPresent(UserIntegrationMappings.self, forKey: .modifiedBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(partnerItem, forKey: .partnerItem)
        try container.encode(boxItem, forKey: .boxItem)
        try container.encodeIfPresent(integrationType, forKey: .integrationType)
        try container.encodeIfPresent(isManuallyCreated, forKey: .isManuallyCreated)
        try container.encodeIfPresent(options, forKey: .options)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(modifiedBy, forKey: .modifiedBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try super.encode(to: encoder)
    }

}
