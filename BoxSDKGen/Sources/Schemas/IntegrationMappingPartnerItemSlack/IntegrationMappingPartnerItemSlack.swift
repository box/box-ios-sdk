import Foundation

/// The schema for an integration mapping mapped item object for type Slack.
/// 
/// Depending if Box for Slack is installed at the org or workspace level,
/// provide **either** `slack_org_id` **or** `slack_workspace_id`.
/// Do not use both parameters at the same time.
public class IntegrationMappingPartnerItemSlack: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case slackWorkspaceId = "slack_workspace_id"
        case slackOrgId = "slack_org_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// ID of the mapped item (of type referenced in `type`).
    public let id: String

    /// Type of the mapped item referenced in `id`.
    public let type: IntegrationMappingPartnerItemSlackTypeField

    /// ID of the Slack workspace with which the item is associated. Use this parameter if Box for Slack is installed at a workspace level. Do not use `slack_org_id` at the same time.
    @CodableTriState public private(set) var slackWorkspaceId: String?

    /// ID of the Slack org with which the item is associated. Use this parameter if Box for Slack is installed at the org level. Do not use `slack_workspace_id` at the same time.
    @CodableTriState public private(set) var slackOrgId: String?

    /// Initializer for a IntegrationMappingPartnerItemSlack.
    ///
    /// - Parameters:
    ///   - id: ID of the mapped item (of type referenced in `type`).
    ///   - type: Type of the mapped item referenced in `id`.
    ///   - slackWorkspaceId: ID of the Slack workspace with which the item is associated. Use this parameter if Box for Slack is installed at a workspace level. Do not use `slack_org_id` at the same time.
    ///   - slackOrgId: ID of the Slack org with which the item is associated. Use this parameter if Box for Slack is installed at the org level. Do not use `slack_workspace_id` at the same time.
    public init(id: String, type: IntegrationMappingPartnerItemSlackTypeField = IntegrationMappingPartnerItemSlackTypeField.channel, slackWorkspaceId: TriStateField<String> = nil, slackOrgId: TriStateField<String> = nil) {
        self.id = id
        self.type = type
        self._slackWorkspaceId = CodableTriState(state: slackWorkspaceId)
        self._slackOrgId = CodableTriState(state: slackOrgId)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(IntegrationMappingPartnerItemSlackTypeField.self, forKey: .type)
        slackWorkspaceId = try container.decodeIfPresent(String.self, forKey: .slackWorkspaceId)
        slackOrgId = try container.decodeIfPresent(String.self, forKey: .slackOrgId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(field: _slackWorkspaceId.state, forKey: .slackWorkspaceId)
        try container.encode(field: _slackOrgId.state, forKey: .slackOrgId)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
