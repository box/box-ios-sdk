//
//  EventsSpecs.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 02/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class EventsModuleSpecs: QuickSpec {

    var sut: BoxClient!

    override func spec() {
        beforeEach {
            self.sut = BoxSDK.getClient(token: "asdads")
        }

        afterEach {
            OHHTTPStubs.removeAllStubs()
        }

        describe("getUserEvents()") {
            context("stream position set to now") {
                it("should make API call to get user events") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/events") &&
                            containsQueryParams(["stream_type": "all", "stream_position": "now", "limit": "25"]) &&
                            isMethodGET(),
                        response: { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetUserEvents.json", type(of: self))!,
                                statusCode: 200, headers: [:]
                            )
                        }
                    )

                    waitUntil(timeout: 10) { done in
                        self.sut.events.getUserEvents(streamType: .all, streamPosition: .now, limit: 25) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(event):
                                        expect(event).toNot(beNil())
                                        expect(event).to(beAKindOf(Event.self))
                                        expect(event.id).to(equal("f82c3ba03e41f7e8a7608363cc6c0390183c3f83"))
                                        expect(event.createdBy?.id).to(equal("11111"))
                                        expect(event.eventType).to(equal(.itemCreated))
                                        expect(event.sessionId).to(equal("70090280850c8d2a1933c1"))

                                    case let .failure(error):
                                        fail("Unable to get event details, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get event details, but instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            context("custom stream position") {
                // simulating stream position that was not implemented yet
                let customStreamPosition = StreamPosition.customValue("today")
                it("should make API call to get user events") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/events") &&
                            containsQueryParams(["stream_type": "all", "stream_position": customStreamPosition.description, "limit": "25"]) &&
                            isMethodGET(),
                        response: { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetUserEvents.json", type(of: self))!,
                                statusCode: 200, headers: [:]
                            )
                        }
                    )

                    waitUntil(timeout: 10) { done in
                        self.sut.events.getUserEvents(streamType: .all, streamPosition: customStreamPosition, limit: 25) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(event):
                                        expect(event).toNot(beNil())
                                        expect(event).to(beAKindOf(Event.self))
                                        expect(event.id).to(equal("f82c3ba03e41f7e8a7608363cc6c0390183c3f83"))
                                        expect(event.createdBy?.id).to(equal("11111"))
                                        expect(event.eventType).to(equal(.itemCreated))
                                        expect(event.sessionId).to(equal("70090280850c8d2a1933c1"))

                                    case let .failure(error):
                                        fail("Unable to get event details, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get event details, but instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            context("custom stream position set to none") {
                it("should make API call to get user events") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/events") &&
                            containsQueryParams(["stream_type": "all", "limit": "25"]) &&
                            isMethodGET(),
                        response: { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetUserEvents.json", type(of: self))!,
                                statusCode: 200, headers: [:]
                            )
                        }
                    )

                    waitUntil(timeout: 10) { done in
                        self.sut.events.getUserEvents(streamType: .all, limit: 25) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(event):
                                        expect(event).toNot(beNil())
                                        expect(event).to(beAKindOf(Event.self))
                                        expect(event.id).to(equal("f82c3ba03e41f7e8a7608363cc6c0390183c3f83"))
                                        expect(event.createdBy?.id).to(equal("11111"))
                                        expect(event.eventType).to(equal(.itemCreated))
                                        expect(event.sessionId).to(equal("70090280850c8d2a1933c1"))

                                    case let .failure(error):
                                        fail("Unable to get event details, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get event details, but instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            context("Stream position set to zero") {
                it("should make API call to get user events") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/events") &&
                            containsQueryParams(["stream_type": "all", "stream_position": "0", "limit": "25"]) &&
                            isMethodGET(),
                        response: { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetUserEvents.json", type(of: self))!,
                                statusCode: 200, headers: [:]
                            )
                        }
                    )

                    waitUntil(timeout: 10) { done in
                        self.sut.events.getUserEvents(streamType: .all, streamPosition: .zero, limit: 25) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(event):
                                        expect(event).toNot(beNil())
                                        expect(event).to(beAKindOf(Event.self))
                                        expect(event.id).to(equal("f82c3ba03e41f7e8a7608363cc6c0390183c3f83"))
                                        expect(event.createdBy?.id).to(equal("11111"))
                                        expect(event.eventType).to(equal(.itemCreated))
                                        expect(event.sessionId).to(equal("70090280850c8d2a1933c1"))

                                    case let .failure(error):
                                        fail("Unable to get event details, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get event details, but instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }
        }

        describe("getEnterpriseEvents()") {

            let createdAfter: Date = Date()

            it("should make API call to get admin events") {
                stub(
                    condition: isHost("api.box.com") &&
                        isPath("/2.0/events") &&
                        containsQueryParams([
                            "stream_type": "admin_logs",
                            "event_type": [EventType.abnormalDownloadActivity.description, EventType.accessGranted.description].joined(separator: ","),
                            "created_after": createdAfter.iso8601,
                            "stream_position": StreamPosition.now.description,
                            "limit": "100"
                        ]) &&
                        isMethodGET(),
                    response: { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetUserEvents.json", type(of: self))!,
                            statusCode: 200, headers: [:]
                        )
                    }
                )

                waitUntil(timeout: 10) { done in
                    self.sut.events.getEnterpriseEvents(
                        eventTypes: [.abnormalDownloadActivity, .accessGranted],
                        createdAfter: createdAfter,
                        streamPosition: .now,
                        limit: 100
                    ) { results in
                        switch results {
                        case let .success(iterator):
                            iterator.next { result in
                                switch result {
                                case let .success(event):
                                    expect(event).toNot(beNil())
                                    expect(event).to(beAKindOf(Event.self))
                                    expect(event.id).to(equal("f82c3ba03e41f7e8a7608363cc6c0390183c3f83"))
                                    expect(event.createdBy?.id).to(equal("11111"))
                                    expect(event.eventType).to(equal(.itemCreated))
                                    expect(event.sessionId).to(equal("70090280850c8d2a1933c1"))

                                case let .failure(error):
                                    fail("Unable to get event details, but instead got \(error)")
                                }
                                done()
                            }
                        case let .failure(error):
                            fail("Unable to get event details, but instead got \(error)")
                            done()
                        }
                    }
                }
            }
        }

        describe("getPollingURL()") {
            it("should make API call to get url for polling request to observe on new events") {
                stub(
                    condition: isHost("api.box.com") &&
                        isPath("/2.0/events"),
                    response: { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetPollingURL.json", type(of: self))!,
                            statusCode: 200, headers: [:]
                        )
                    }
                )

                waitUntil(timeout: 100) { done in
                    self.sut.events.getPollingURL() { result in
                        switch result {
                        case let .success(pollingURLInfo):
                            expect(pollingURLInfo.url.absoluteString).to(equal("http://2.realtime.services.box.net/subscribe?channel=cc807c9c4869ffb1c81a&stream_type=all"))
                            expect(pollingURLInfo.maxRetries).to(equal("10"))
                            expect(pollingURLInfo.timeoutInSeconds).to(equal(610))
                        case let .failure(error):
                            fail("Unable to get polling url info, insted got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("observeForNewEvents()") {
            it("should observe for new changes and get a result from server either informing about new changes or instructing to reconnect") {
                stub(
                    condition:
                    isMethodGET(),
                    response: { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetNewEvents.json", type(of: self))!,
                            statusCode: 200, headers: [:]
                        )
                    }
                )

                guard let pollingURLInfo = try? PollingURLInfo(json: [
                    "chunk_size": 1,
                    "entries": [["type": "realtime_server",
                                 "url": "http://2.realtime.services.box.net/subscribe?channel=cc807c9c4869ffb1c81a&stream_type=all",
                                 "ttl": "10",
                                 "max_retries": "10",
                                 "retry_timeout": 610]]
                ]) else {
                    fail("Unable to create polling url info from file")
                    return
                }
                waitUntil(timeout: 1000) { done in
                    self.sut.events.observeForNewEvents(with: pollingURLInfo) { result in
                        switch result {
                        case let .success(pollingResult):
                            expect(pollingResult.version).to(equal(1))
                            expect(pollingResult.message).to(equal(.reconnect))
                        case let .failure(error):
                            fail("Unable to get polling reponse, instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }
    }
}
