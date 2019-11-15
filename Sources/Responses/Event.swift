//
//  Event.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 29/07/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// An event object associated with user or enterprise events.
public class Event: BoxModel {

    private static var resourceType: String = "event"
    /// Box event object type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// The user that performed the action represented by the event. Some events may be performed by users not logged into Box.
    /// In that case, not all attributes of the object are populated and the event is attributed to a unknown user.
    public let createdBy: User?
    /// One of the event types.
    public let eventType: EventType
    /// The session ID of the user who performed the action represented by the event.
    public let sessionId: String?
    /// The object associated with the event.
    public let source: EventItem?

    /// When the event occurred (when the user performed the action).
    public let createdAt: Date?
    /// When the event was stored in the Box database.
    public let recordedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let objectType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard objectType == Event.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: objectType, acceptedValues: [Event.resourceType]))
        }

        type = objectType
        rawData = json

        id = try BoxJSONDecoder.decode(json: json, forKey: "event_id")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        eventType = try BoxJSONDecoder.decodeEnum(json: json, forKey: "event_type")
        sessionId = try BoxJSONDecoder.optionalDecode(json: json, forKey: "session_id")
        source = try BoxJSONDecoder.optionalDecode(json: json, forKey: "source")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        recordedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "recorded_at")
    }
}
