//
//  EventsModule.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 29/07/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Stream position used for stream pagination
public enum StreamPosition: BoxEnum {
    /// When used, Box API will return 0 events and the latest streamPosition value to be used for subsequent call.
    case now
    /// When used, Box API will return all available events.
    case zero
    /// Custom value of a stream position used when using value not yet implemented in this SDK (of similar usage as none, now or zero)
    case customValue(String)

    /// Creates a new value
    ///
    /// - Parameter value: String representation of a StreamPosition rawValue
    public init(_ value: String) {
        switch value {
        case "now":
            self = .now
        case "0":
            self = .zero
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of StreamPosition
    public var description: String {
        switch self {
        case .now:
            return "now"
        case .zero:
            return "0"
        case let .customValue(value):
            return value
        }
    }
}

/// Restricts the types of events returned.
public enum StreamType: BoxEnum {
    /// Stream returns all user events
    case all
    /// Stream returns events that may cause file tree changes such as file updates or collaborations
    case changes
    /// Stream returns enterprise-wide events available for administrators
    case sync
    /// A custom stream type that is not yet implemented
    case customValue(String)

    /// Creates a new value
    ///
    /// - Parameter value: String representation of an StreamType rawValue
    public init(_ value: String) {
        switch value {
        case "all":
            self = .all
        case "changes":
            self = .changes
        case "sync":
            self = .sync
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of StreamType
    public var description: String {
        switch self {
        case .all:
            return "all"
        case .changes:
            return "changes"
        case .sync:
            return "sync"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Defines results for a request checking for new changes in user events
public enum EventObserverResponse: BoxEnum {
    /// New event appeared.
    case newChange
    /// No new events appeared. Request for a new polling URL.
    case reconnect
    /// Value that was not yet implemented in this SDK
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of a response.
    public init(_ value: String) {
        switch value {
        case "new_change":
            self = .newChange
        case "reconnect":
            self = .reconnect
        default:
            self = .customValue(value)
        }
    }

    /// String representation of the reponse.
    public var description: String {
        switch self {
        case .newChange:
            return "new_change"
        case .reconnect:
            return "reconnect"
        case let .customValue(value):
            return value
        }
    }
}

/// Provides [Event](../Structs/Event.html) management.
public class EventsModule {

    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer.
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Gets events for the current user associated with the access token.
    /// Due to emphasis on returning complete results quickly, Box may return duplicate or out of order events.
    /// Duplicate events can be identified by their event IDs. User events are stored for between two weeks and two months,
    /// after which the user events are removed.
    ///
    /// - Parameters:
    ///   - streamType: Restricts the types of events returned.
    ///   - streamPosition: The location in the event stream from which you want to start receiving events. If no stream position specified
    ///     Box API will return all available events beginning with the oldest stream position.
    ///   - limit: The maximum number of items to return. If not specified, [default API limit](https://developer.box.com/reference#get-events-for-a-user) is used.
    /// - Returns: Either collection of events or an error.
    public func getUserEvents(
        streamType: StreamType? = nil,
        streamPosition: StreamPosition? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<Event>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/events", configuration: boxClient.configuration),
            queryParameters: [
                "stream_type": streamType?.description,
                "stream_position": streamPosition?.description,
                "limit": limit
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Gets events for all users and content in the enterprise. Enterprise events are accessible for one year via the API,
    /// and seven years via exported reports in the Box Admin Console.
    ///
    /// - Parameters:
    ///   - evenType: Restricts returned value to listed events.
    ///   - createdAfter: A lower bound on the timestamp of the events returned.
    ///   - createdBefore: An upper bound on the timestamp of the events returned.
    ///   - streamPosition: The location in the event stream from which you want to start receiving events.
    ///   - limit: The maximum number of items to return.
    /// - Returns: Either collection of events or an error.
    public func getEnterpriseEvents(
        eventTypes: [EventType]? = nil,
        createdAfter: Date? = nil,
        createdBefore: Date? = nil,
        streamPosition: StreamPosition? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<Event>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/events", configuration: boxClient.configuration),
            queryParameters: [
                "stream_type": "admin_logs",
                "event_type": eventTypes?.map { $0.description }.queryParamValue,
                "created_after": createdAfter?.iso8601,
                "created_before": createdBefore?.iso8601,
                "stream_position": streamPosition?.description,
                "limit": limit
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Gets polling URL for checking new changes in an event stream. Works only for user events.
    ///
    /// - Parameter completion: Returns either polling url information or an error.
    public func getPollingURL(completion: @escaping (Result<PollingURLInfo, BoxSDKError>) -> Void) {
        boxClient.options(url: URL.boxAPIEndpoint("/2.0/events", configuration: boxClient.configuration)) { result in
            let objectResult: Result<PollingURLInfo, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }
            completion(objectResult)
        }
    }

    /// Makes long-polling request for new changes. Server does not return response immediatelly. It only returns response when either
    /// a new change was detected or a new request for long polling is made.
    /// Check the timeout value in the PollingURLInfo object to determine the time that the next long-polling request should be made.
    ///
    /// - Parameters:
    ///   - url: Long polling URL info.
    ///   - completion: Returns either an event observer response or an error.
    public func observeForNewEvents(with urlInfo: PollingURLInfo, completion: @escaping (Result<PollingResult, BoxSDKError>) -> Void) {
        boxClient.get(url: urlInfo.url) { result in
            let objectResult: Result<PollingResult, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }
            completion(objectResult)
        }
    }
}
