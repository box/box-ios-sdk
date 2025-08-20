import Foundation

/// A Box Skill metadata card that places a list of images on a
/// timeline.
public class TimelineSkillCard: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case skill
        case invocation
        case entries
        case createdAt = "created_at"
        case type
        case skillCardType = "skill_card_type"
        case skillCardTitle = "skill_card_title"
        case duration
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The service that applied this metadata.
    public let skill: TimelineSkillCardSkillField

    /// The invocation of this service, used to track
    /// which instance of a service applied the metadata.
    public let invocation: TimelineSkillCardInvocationField

    /// A list of entries on the timeline.
    public let entries: [TimelineSkillCardEntriesField]

    /// The optional date and time this card was created at.
    public let createdAt: Date?

    /// The value will always be `skill_card`.
    public let type: TimelineSkillCardTypeField

    /// The value will always be `timeline`.
    public let skillCardType: TimelineSkillCardSkillCardTypeField

    /// The title of the card.
    public let skillCardTitle: TimelineSkillCardSkillCardTitleField?

    /// An total duration in seconds of the timeline.
    public let duration: Int64?

    /// Initializer for a TimelineSkillCard.
    ///
    /// - Parameters:
    ///   - skill: The service that applied this metadata.
    ///   - invocation: The invocation of this service, used to track
    ///     which instance of a service applied the metadata.
    ///   - entries: A list of entries on the timeline.
    ///   - createdAt: The optional date and time this card was created at.
    ///   - type: The value will always be `skill_card`.
    ///   - skillCardType: The value will always be `timeline`.
    ///   - skillCardTitle: The title of the card.
    ///   - duration: An total duration in seconds of the timeline.
    public init(skill: TimelineSkillCardSkillField, invocation: TimelineSkillCardInvocationField, entries: [TimelineSkillCardEntriesField], createdAt: Date? = nil, type: TimelineSkillCardTypeField = TimelineSkillCardTypeField.skillCard, skillCardType: TimelineSkillCardSkillCardTypeField = TimelineSkillCardSkillCardTypeField.timeline, skillCardTitle: TimelineSkillCardSkillCardTitleField? = nil, duration: Int64? = nil) {
        self.skill = skill
        self.invocation = invocation
        self.entries = entries
        self.createdAt = createdAt
        self.type = type
        self.skillCardType = skillCardType
        self.skillCardTitle = skillCardTitle
        self.duration = duration
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        skill = try container.decode(TimelineSkillCardSkillField.self, forKey: .skill)
        invocation = try container.decode(TimelineSkillCardInvocationField.self, forKey: .invocation)
        entries = try container.decode([TimelineSkillCardEntriesField].self, forKey: .entries)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        type = try container.decode(TimelineSkillCardTypeField.self, forKey: .type)
        skillCardType = try container.decode(TimelineSkillCardSkillCardTypeField.self, forKey: .skillCardType)
        skillCardTitle = try container.decodeIfPresent(TimelineSkillCardSkillCardTitleField.self, forKey: .skillCardTitle)
        duration = try container.decodeIfPresent(Int64.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(skill, forKey: .skill)
        try container.encode(invocation, forKey: .invocation)
        try container.encode(entries, forKey: .entries)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encode(type, forKey: .type)
        try container.encode(skillCardType, forKey: .skillCardType)
        try container.encodeIfPresent(skillCardTitle, forKey: .skillCardTitle)
        try container.encodeIfPresent(duration, forKey: .duration)
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
