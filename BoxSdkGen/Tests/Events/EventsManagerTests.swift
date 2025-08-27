import Foundation
import BoxSdkGen
import XCTest

class EventsManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testEvents() async throws {
        await runWithRetryAsync {
            let events: Events = try await client.events.getEvents()
            XCTAssertTrue(events.entries!.count > 0)
            let firstEvent: Event = events.entries![0]
            XCTAssertTrue(Utils.Strings.toString(value: firstEvent.createdBy!.type) == "user")
            XCTAssertTrue(Utils.Strings.toString(value: firstEvent.eventType!) != "")
        }
    }

    public func testEventUpload() async throws {
        await runWithRetryAsync {
            let events: Events = try await client.events.getEvents(queryParams: GetEventsQueryParams(streamType: GetEventsQueryParamsStreamTypeField.adminLogs, eventType: [GetEventsQueryParamsEventTypeField.upload]))
            XCTAssertTrue(events.entries!.count > 0)
            let firstEvent: Event = events.entries![0]
            XCTAssertTrue(Utils.Strings.toString(value: firstEvent.eventType!) == "UPLOAD")
        }
    }

    public func testEventDeleteUser() async throws {
        await runWithRetryAsync {
            let events: Events = try await client.events.getEvents(queryParams: GetEventsQueryParams(streamType: GetEventsQueryParamsStreamTypeField.adminLogs, eventType: [GetEventsQueryParamsEventTypeField.deleteUser]))
            XCTAssertTrue(events.entries!.count > 0)
            let firstEvent: Event = events.entries![0]
            XCTAssertTrue(Utils.Strings.toString(value: firstEvent.eventType!) == "DELETE_USER")
        }
    }

    public func testEventSourceFileOrFolder() async throws {
        await runWithRetryAsync {
            let events: Events = try await client.events.getEvents(queryParams: GetEventsQueryParams(streamType: GetEventsQueryParamsStreamTypeField.changes))
            XCTAssertTrue(events.entries!.count > 0)
        }
    }

    public func testGetEventsWithLongPolling() async throws {
        await runWithRetryAsync {
            let servers: RealtimeServers = try await client.events.getEventsWithLongPolling()
            XCTAssertTrue(servers.entries!.count > 0)
            let server: RealtimeServer = servers.entries![0]
            XCTAssertTrue(Utils.Strings.toString(value: server.type!) == "realtime_server")
            XCTAssertTrue(server.url! != "")
        }
    }

    public func testGetEventsWithDateFilters() async throws {
        await runWithRetryAsync {
            let currentEpochTimeInSeconds: Int64 = Utils.Dates.getEpochTimeInSeconds()
            let epochTimeInSecondsAWeekAgo: Int64 = currentEpochTimeInSeconds - 7 * 24 * 60 * 60
            let createdAfterDate: Date = Utils.Dates.epochSecondsToDateTime(seconds: epochTimeInSecondsAWeekAgo)
            let createdBeforeDate: Date = Utils.Dates.epochSecondsToDateTime(seconds: currentEpochTimeInSeconds)
            let servers: Events = try await client.events.getEvents(queryParams: GetEventsQueryParams(streamType: GetEventsQueryParamsStreamTypeField.adminLogs, limit: Int64(1), createdAfter: createdAfterDate, createdBefore: createdBeforeDate))
            XCTAssertTrue(servers.entries!.count == 1)
        }
    }
}
