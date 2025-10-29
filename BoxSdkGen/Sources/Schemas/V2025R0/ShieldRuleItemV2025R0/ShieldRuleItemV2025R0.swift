import Foundation

/// A Shield rule item.
public class ShieldRuleItemV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case ruleCategory = "rule_category"
        case name
        case description
        case priority
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The identifier of the shield rule.
    public let id: String?

    /// The value will always be `shield_rule`.
    public let type: ShieldRuleItemV2025R0TypeField?

    /// The category of the shield rule.
    public let ruleCategory: String?

    /// The name of the shield rule.
    public let name: String?

    /// The description of the shield rule.
    public let description: String?

    /// The priority level of the shield rule.
    public let priority: ShieldRuleItemV2025R0PriorityField?

    /// The date and time when the shield rule was created.
    public let createdAt: Date?

    /// The date and time when the shield rule was last modified.
    public let modifiedAt: Date?

    /// Initializer for a ShieldRuleItemV2025R0.
    ///
    /// - Parameters:
    ///   - id: The identifier of the shield rule.
    ///   - type: The value will always be `shield_rule`.
    ///   - ruleCategory: The category of the shield rule.
    ///   - name: The name of the shield rule.
    ///   - description: The description of the shield rule.
    ///   - priority: The priority level of the shield rule.
    ///   - createdAt: The date and time when the shield rule was created.
    ///   - modifiedAt: The date and time when the shield rule was last modified.
    public init(id: String? = nil, type: ShieldRuleItemV2025R0TypeField? = nil, ruleCategory: String? = nil, name: String? = nil, description: String? = nil, priority: ShieldRuleItemV2025R0PriorityField? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil) {
        self.id = id
        self.type = type
        self.ruleCategory = ruleCategory
        self.name = name
        self.description = description
        self.priority = priority
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(ShieldRuleItemV2025R0TypeField.self, forKey: .type)
        ruleCategory = try container.decodeIfPresent(String.self, forKey: .ruleCategory)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        priority = try container.decodeIfPresent(ShieldRuleItemV2025R0PriorityField.self, forKey: .priority)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(ruleCategory, forKey: .ruleCategory)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(priority, forKey: .priority)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
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
