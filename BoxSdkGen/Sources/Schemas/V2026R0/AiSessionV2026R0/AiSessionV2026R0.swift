import Foundation

/// A standard representation of an AI session. An AI session holds the
/// conversation state for a series of interactions with a Box AI agent. Its `id`
/// is the A2A context identifier for that conversation.
public class AiSessionV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case updatedBy = "updated_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case type
        case name
        case source
        case clientId = "client_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the AI session. This is also the A2A
    /// `contextId` for the conversation. Treat the value as opaque.
    public let id: String

    public let createdBy: UserBaseV2026R0

    public let updatedBy: UserBaseV2026R0

    /// The date and time when the AI session was created.
    public let createdAt: Date

    /// The date and time when the AI session was last updated. It advances on
    /// each turn of session activity, so it also serves as the most recently
    /// used ordering.
    public let updatedAt: Date

    /// The value is always `ai_session`.
    public let type: AiSessionV2026R0TypeField

    /// The display name of the AI session. Sessions created through the A2A API
    /// are named automatically. The value is `null` only when no name was
    /// recorded.
    @CodableTriState public private(set) var name: String?

    /// The origin of the AI session. Currently always `api`. New values
    /// may be added, so clients must tolerate values they do not recognize.
    public let source: AiSessionV2026R0SourceField

    /// The OAuth client ID of the application that created the AI session, as
    /// shown in the Developer Console. The value is `null` if the application is
    /// not known.
    @CodableTriState public private(set) var clientId: String?

    /// Initializer for a AiSessionV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the AI session. This is also the A2A
    ///     `contextId` for the conversation. Treat the value as opaque.
    ///   - createdBy: 
    ///   - updatedBy: 
    ///   - createdAt: The date and time when the AI session was created.
    ///   - updatedAt: The date and time when the AI session was last updated. It advances on
    ///     each turn of session activity, so it also serves as the most recently
    ///     used ordering.
    ///   - type: The value is always `ai_session`.
    ///   - name: The display name of the AI session. Sessions created through the A2A API
    ///     are named automatically. The value is `null` only when no name was
    ///     recorded.
    ///   - source: The origin of the AI session. Currently always `api`. New values
    ///     may be added, so clients must tolerate values they do not recognize.
    ///   - clientId: The OAuth client ID of the application that created the AI session, as
    ///     shown in the Developer Console. The value is `null` if the application is
    ///     not known.
    public init(id: String, createdBy: UserBaseV2026R0, updatedBy: UserBaseV2026R0, createdAt: Date, updatedAt: Date, type: AiSessionV2026R0TypeField = AiSessionV2026R0TypeField.aiSession, name: TriStateField<String> = nil, source: AiSessionV2026R0SourceField = AiSessionV2026R0SourceField.api, clientId: TriStateField<String> = nil) {
        self.id = id
        self.createdBy = createdBy
        self.updatedBy = updatedBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.type = type
        self._name = CodableTriState(state: name)
        self.source = source
        self._clientId = CodableTriState(state: clientId)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        createdBy = try container.decode(UserBaseV2026R0.self, forKey: .createdBy)
        updatedBy = try container.decode(UserBaseV2026R0.self, forKey: .updatedBy)
        createdAt = try container.decodeDateTime(forKey: .createdAt)
        updatedAt = try container.decodeDateTime(forKey: .updatedAt)
        type = try container.decode(AiSessionV2026R0TypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        source = try container.decode(AiSessionV2026R0SourceField.self, forKey: .source)
        clientId = try container.decodeIfPresent(String.self, forKey: .clientId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdBy, forKey: .createdBy)
        try container.encode(updatedBy, forKey: .updatedBy)
        try container.encodeDateTime(field: createdAt, forKey: .createdAt)
        try container.encodeDateTime(field: updatedAt, forKey: .updatedAt)
        try container.encode(type, forKey: .type)
        try container.encode(field: _name.state, forKey: .name)
        try container.encode(source, forKey: .source)
        try container.encode(field: _clientId.state, forKey: .clientId)
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
