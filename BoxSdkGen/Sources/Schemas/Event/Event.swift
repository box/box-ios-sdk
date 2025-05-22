import Foundation

/// The description of an event that happened within Box
public class Event: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case createdAt = "created_at"
        case recordedAt = "recorded_at"
        case eventId = "event_id"
        case createdBy = "created_by"
        case eventType = "event_type"
        case sessionId = "session_id"
        case source
        case additionalDetails = "additional_details"
    }

    /// `event`
    public let type: String?

    /// When the event object was created
    public let createdAt: Date?

    /// When the event object was recorded in database
    public let recordedAt: Date?

    /// The ID of the event object. You can use this to detect duplicate events
    public let eventId: String?

    public let createdBy: UserMini?

    public let eventType: EventEventTypeField?

    /// The session of the user that performed the action. Not all events will
    /// populate this attribute.
    public let sessionId: String?

    public let source: AppItemEventSourceOrEventSourceOrFileOrFolderOrGenericSourceOrUser?

    /// This object provides additional information about the event if available.
    /// 
    /// This can include how a user performed an event as well as additional
    /// information to correlate an event to external KeySafe logs. Not all events
    /// have an `additional_details` object.  This object is only available in the
    /// Enterprise Events.
    public let additionalDetails: EventAdditionalDetailsField?

    /// Initializer for a Event.
    ///
    /// - Parameters:
    ///   - type: `event`
    ///   - createdAt: When the event object was created
    ///   - recordedAt: When the event object was recorded in database
    ///   - eventId: The ID of the event object. You can use this to detect duplicate events
    ///   - createdBy: 
    ///   - eventType: 
    ///   - sessionId: The session of the user that performed the action. Not all events will
    ///     populate this attribute.
    ///   - source: 
    ///   - additionalDetails: This object provides additional information about the event if available.
    ///     
    ///     This can include how a user performed an event as well as additional
    ///     information to correlate an event to external KeySafe logs. Not all events
    ///     have an `additional_details` object.  This object is only available in the
    ///     Enterprise Events.
    public init(type: String? = nil, createdAt: Date? = nil, recordedAt: Date? = nil, eventId: String? = nil, createdBy: UserMini? = nil, eventType: EventEventTypeField? = nil, sessionId: String? = nil, source: AppItemEventSourceOrEventSourceOrFileOrFolderOrGenericSourceOrUser? = nil, additionalDetails: EventAdditionalDetailsField? = nil) {
        self.type = type
        self.createdAt = createdAt
        self.recordedAt = recordedAt
        self.eventId = eventId
        self.createdBy = createdBy
        self.eventType = eventType
        self.sessionId = sessionId
        self.source = source
        self.additionalDetails = additionalDetails
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        recordedAt = try container.decodeDateTimeIfPresent(forKey: .recordedAt)
        eventId = try container.decodeIfPresent(String.self, forKey: .eventId)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        eventType = try container.decodeIfPresent(EventEventTypeField.self, forKey: .eventType)
        sessionId = try container.decodeIfPresent(String.self, forKey: .sessionId)
        source = try container.decodeIfPresent(AppItemEventSourceOrEventSourceOrFileOrFolderOrGenericSourceOrUser.self, forKey: .source)
        additionalDetails = try container.decodeIfPresent(EventAdditionalDetailsField.self, forKey: .additionalDetails)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: recordedAt, forKey: .recordedAt)
        try container.encodeIfPresent(eventId, forKey: .eventId)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(eventType, forKey: .eventType)
        try container.encodeIfPresent(sessionId, forKey: .sessionId)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(additionalDetails, forKey: .additionalDetails)
    }

}
