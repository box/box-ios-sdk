import Foundation

/// The metadata assigned to a using for Box skills.
public class SkillCardsMetadata: Codable {
    private enum CodingKeys: String, CodingKey {
        case canEdit = "$canEdit"
        case id = "$id"
        case parent = "$parent"
        case scope = "$scope"
        case template = "$template"
        case type = "$type"
        case typeVersion = "$typeVersion"
        case version = "$version"
        case cards
    }

    /// Whether the user can edit this metadata
    public let canEdit: Bool?

    /// A UUID to identify the metadata object
    public let id: String?

    /// An ID for the parent folder
    public let parent: String?

    /// An ID for the scope in which this template
    /// has been applied
    public let scope: String?

    /// The name of the template
    public let template: String?

    /// A unique identifier for the "type" of this instance. This is an internal
    /// system property and should not be used by a client application.
    public let type: String?

    /// The last-known version of the template of the object. This is an internal
    /// system property and should not be used by a client application.
    public let typeVersion: Int64?

    /// The version of the metadata object. Starts at 0 and increases every time
    /// a user-defined property is modified.
    public let version: Int64?

    /// A list of Box Skill cards that have been applied to this file.
    public let cards: [KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard]?

    /// Initializer for a SkillCardsMetadata.
    ///
    /// - Parameters:
    ///   - canEdit: Whether the user can edit this metadata
    ///   - id: A UUID to identify the metadata object
    ///   - parent: An ID for the parent folder
    ///   - scope: An ID for the scope in which this template
    ///     has been applied
    ///   - template: The name of the template
    ///   - type: A unique identifier for the "type" of this instance. This is an internal
    ///     system property and should not be used by a client application.
    ///   - typeVersion: The last-known version of the template of the object. This is an internal
    ///     system property and should not be used by a client application.
    ///   - version: The version of the metadata object. Starts at 0 and increases every time
    ///     a user-defined property is modified.
    ///   - cards: A list of Box Skill cards that have been applied to this file.
    public init(canEdit: Bool? = nil, id: String? = nil, parent: String? = nil, scope: String? = nil, template: String? = nil, type: String? = nil, typeVersion: Int64? = nil, version: Int64? = nil, cards: [KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard]? = nil) {
        self.canEdit = canEdit
        self.id = id
        self.parent = parent
        self.scope = scope
        self.template = template
        self.type = type
        self.typeVersion = typeVersion
        self.version = version
        self.cards = cards
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canEdit = try container.decodeIfPresent(Bool.self, forKey: .canEdit)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        parent = try container.decodeIfPresent(String.self, forKey: .parent)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)
        template = try container.decodeIfPresent(String.self, forKey: .template)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        typeVersion = try container.decodeIfPresent(Int64.self, forKey: .typeVersion)
        version = try container.decodeIfPresent(Int64.self, forKey: .version)
        cards = try container.decodeIfPresent([KeywordSkillCardOrStatusSkillCardOrTimelineSkillCardOrTranscriptSkillCard].self, forKey: .cards)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(canEdit, forKey: .canEdit)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(scope, forKey: .scope)
        try container.encodeIfPresent(template, forKey: .template)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(typeVersion, forKey: .typeVersion)
        try container.encodeIfPresent(version, forKey: .version)
        try container.encodeIfPresent(cards, forKey: .cards)
    }

}
