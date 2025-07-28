import Foundation

public class EventsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns a list of real-time servers that can be used for long-polling updates
    /// to the [event stream](#get-events).
    /// 
    /// Long polling is the concept where a HTTP request is kept open until the
    /// server sends a response, then repeating the process over and over to receive
    /// updated responses.
    /// 
    /// Long polling the event stream can only be used for user events, not for
    /// enterprise events.
    /// 
    /// To use long polling, first use this endpoint to retrieve a list of long poll
    /// URLs. Next, make a long poll request to any of the provided URLs.
    /// 
    /// When an event occurs in monitored account a response with the value
    /// `new_change` will be sent. The response contains no other details as
    /// it only serves as a prompt to take further action such as sending a
    /// request to the [events endpoint](#get-events) with the last known
    /// `stream_position`.
    /// 
    /// After the server sends this response it closes the connection. You must now
    /// repeat the long poll process to begin listening for events again.
    /// 
    /// If no events occur for a while and the connection times out you will
    /// receive a response with the value `reconnect`. When you receive this response
    /// you’ll make another call to this endpoint to restart the process.
    /// 
    /// If you receive no events in `retry_timeout` seconds then you will need to
    /// make another request to the real-time server (one of the URLs in the response
    /// for this endpoint). This might be necessary due to network errors.
    /// 
    /// Finally, if you receive a `max_retries` error when making a request to the
    /// real-time server, you should start over by making a call to this endpoint
    /// first.
    ///
    /// - Parameters:
    ///   - headers: Headers of getEventsWithLongPolling method
    /// - Returns: The `RealtimeServers`.
    /// - Throws: The `GeneralError`.
    public func getEventsWithLongPolling(headers: GetEventsWithLongPollingHeaders = GetEventsWithLongPollingHeaders()) async throws -> RealtimeServers {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/events")", method: "OPTIONS", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try RealtimeServers.deserialize(from: response.data!)
    }

    /// Returns up to a year of past events for a given user
    /// or for the entire enterprise.
    /// 
    /// By default this returns events for the authenticated user. To retrieve events
    /// for the entire enterprise, set the `stream_type` to `admin_logs_streaming`
    /// for live monitoring of new events, or `admin_logs` for querying across
    /// historical events. The user making the API call will
    /// need to have admin privileges, and the application will need to have the
    /// scope `manage enterprise properties` checked.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getEvents method
    ///   - headers: Headers of getEvents method
    /// - Returns: The `Events`.
    /// - Throws: The `GeneralError`.
    public func getEvents(queryParams: GetEventsQueryParams = GetEventsQueryParams(), headers: GetEventsHeaders = GetEventsHeaders()) async throws -> Events {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["stream_type": Utils.Strings.toString(value: queryParams.streamType), "stream_position": Utils.Strings.toString(value: queryParams.streamPosition), "limit": Utils.Strings.toString(value: queryParams.limit), "event_type": Utils.Strings.toString(value: queryParams.eventType), "created_after": Utils.Strings.toString(value: queryParams.createdAfter), "created_before": Utils.Strings.toString(value: queryParams.createdBefore)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/events")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Events.deserialize(from: response.data!)
    }

}
