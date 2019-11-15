//
//  CollaborationWhitelistModuleSpecs.swift
//  BoxSDK
//
//  Created by Daniel Cech on 8/29/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class CollaborationWhitelistModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        describe("CollaborationsWhitelistModule") {
            beforeEach {
                self.sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("listEntries()") {
                it("should retrieve collaboration whitelist entries") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_entries") &&
                            isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetCollaborationWhitelistEntries.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10.0) { done in
                        self.sut.collaborationWhiteList.listEntries { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(firstItem):
                                        expect(firstItem).to(beAKindOf(CollaborationWhitelistEntry.self))
                                        expect(firstItem.id).to(equal("123456"))
                                        expect(firstItem.domain).to(equal("somedomain.com"))
                                        expect(firstItem.direction).to(equal(.inbound))

                                    case let .failure(error):
                                        fail("Unable to get collaboration whitelist items: \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get collaboration whitelist items: \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            describe("get()") {
                it("should retrieve collaboration whitelist entry with particular ID") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_entries/12345") &&
                            isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetCollaborationWhitelistEntryByID.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10.0) { done in
                        self.sut.collaborationWhiteList.get(id: "12345") { result in
                            switch result {
                            case let .success(entry):
                                expect(entry).to(beAKindOf(CollaborationWhitelistEntry.self))
                                expect(entry.id).to(equal("12345"))
                                expect(entry.domain).to(equal("somedomain.com"))
                                expect(entry.direction).to(equal(.outbound))
                                expect(entry.createdAt?.iso8601).to(equal("2019-06-18T18:48:18Z"))
                                expect(entry.modifiedAt?.iso8601).to(equal("2019-01-23T00:19:34Z"))

                                guard let enterprise = entry.enterprise else {
                                    fail("Enterprise object is not present")
                                    done()
                                    return
                                }

                                expect(enterprise).to(beAKindOf(Enterprise.self))
                                expect(enterprise.id).to(equal("98765"))
                                expect(enterprise.name).to(equal("Enterprise"))

                            case let .failure(error):
                                print(error)
                                fail("Unable to get collaboration whitelist item")
                            }

                            done()
                        }
                    }
                }
            }

            describe("create()") {
                it("should create collaboration whitelist entry") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_entries") &&
                            isMethodPOST() &&
                            hasJsonBody([
                                "direction": "both",
                                "domain": "example.com"
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateCollaborationWhitelistEntry.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10.0) { done in
                        self.sut.collaborationWhiteList.create(
                            domain: "example.com",
                            direction: .both
                        ) { result in
                            switch result {
                            case let .success(entry):
                                expect(entry).to(beAKindOf(CollaborationWhitelistEntry.self))
                                expect(entry.id).to(equal("11111"))
                                expect(entry.domain).to(equal("example.com"))
                                expect(entry.direction).to(equal(.both))
                                expect(entry.createdAt?.iso8601).to(equal("2018-04-13T20:53:23Z"))

                                guard let enterprise = entry.enterprise else {
                                    fail("Enterprise object is not present")
                                    done()
                                    return
                                }

                                expect(enterprise).to(beAKindOf(Enterprise.self))
                                expect(enterprise.id).to(equal("22222"))
                                expect(enterprise.name).to(equal("Example Enterprise"))

                            case let .failure(error):
                                print(error)
                                fail("Unable to get collaboration whitelist item")
                            }

                            done()
                        }
                    }
                }
            }

            describe("delete()") {
                it("should delete collaboration whitelist entry") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_entries/12345") &&
                            isMethodDELETE()
                    ) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.collaborationWhiteList.delete(id: "12345") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listExemptTargets()") {
                it("should retrieve collaboration whitelist exempt targets") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_exempt_targets") &&
                            isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetCollaborationWhitelistExemptUsers.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10.0) { done in
                        self.sut.collaborationWhiteList.listExemptTargets { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(firstTarget):
                                        expect(firstTarget).to(beAKindOf(CollaborationWhitelistExemptTarget.self))
                                        expect(firstTarget.id).to(equal("1234567890"))

                                        guard let user = firstTarget.user else {
                                            fail("Target should contain user")
                                            done()
                                            return
                                        }

                                        expect(user).to(beAKindOf(User.self))
                                        expect(user.id).to(equal("12345"))
                                        expect(user.name).to(equal("John Doe"))
                                        expect(user.login).to(equal("john@doe.com"))
                                    case let .failure(error):
                                        fail("Target array should not be empty: \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get collaboration whitelist exempt targets: \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            describe("getExemptTarget()") {
                it("should retrieve collaboration whitelist exempt target with particular ID") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_exempt_targets/12345") &&
                            isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetCollaborationWhitelistExemptUsersByID.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10.0) { done in
                        self.sut.collaborationWhiteList.getExemptTarget(id: "12345") { result in
                            switch result {
                            case let .success(target):
                                expect(target).to(beAKindOf(CollaborationWhitelistExemptTarget.self))
                                expect(target.id).to(equal("12345"))
                                expect(target.createdAt?.iso8601).to(equal("2019-06-18T20:01:49Z"))
                                expect(target.modifiedAt?.iso8601).to(equal("2019-06-18T20:01:49Z"))

                                guard let user = target.user else {
                                    fail("User object is not present")
                                    done()
                                    return
                                }

                                expect(user).to(beAKindOf(User.self))
                                expect(user.id).to(equal("user_id"))
                                expect(user.name).to(equal("John Doe"))
                                expect(user.login).to(equal("john@doe.com"))

                                guard let enterprise = target.enterprise else {
                                    fail("Enterprise object is not present")
                                    done()
                                    return
                                }

                                expect(enterprise).to(beAKindOf(Enterprise.self))
                                expect(enterprise.id).to(equal("123456"))
                                expect(enterprise.name).to(equal("Corporation"))

                            case let .failure(error):
                                print(error)
                                fail("Unable to get collaboration whitelist exempt target item")
                            }

                            done()
                        }
                    }
                }
            }

            describe("exemptUser()") {
                it("should create collaboration whitelist exempt target entry") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_exempt_targets") &&
                            isMethodPOST() &&
                            hasJsonBody(["user": ["id": "12345"]])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateCollaborationWhitelistExemptUser.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10.0) { done in
                        self.sut.collaborationWhiteList.exemptUser(
                            userId: "12345"
                        ) { result in
                            switch result {
                            case let .success(target):
                                expect(target).to(beAKindOf(CollaborationWhitelistExemptTarget.self))
                                expect(target.id).to(equal("collaboration_whitelist_exempt_target_id"))
                                expect(target.createdAt?.iso8601).to(equal("2019-06-18T20:01:49Z"))
                                expect(target.modifiedAt?.iso8601).to(equal("2019-06-18T20:01:49Z"))

                                guard let user = target.user else {
                                    fail("User object is not present")
                                    done()
                                    return
                                }

                                expect(user).to(beAKindOf(User.self))
                                expect(user.id).to(equal("user_id"))
                                expect(user.name).to(equal("John Doe"))
                                expect(user.login).to(equal("john@doe.com"))

                                guard let enterprise = target.enterprise else {
                                    fail("Enterprise object is not present")
                                    done()
                                    return
                                }

                                expect(enterprise).to(beAKindOf(Enterprise.self))
                                expect(enterprise.id).to(equal("123456"))
                                expect(enterprise.name).to(equal("Corporation"))

                            case let .failure(error):
                                print(error)
                                fail("Unable to get collaboration whitelist exempt target item")
                            }

                            done()
                        }
                    }
                }
            }

            describe("deleteExemptTarget()") {
                it("should delete collaboration whitelist exempt target entry") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_exempt_targets/12345") &&
                            isMethodDELETE()
                    ) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.collaborationWhiteList.deleteExemptTarget(id: "12345") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to deleteExemptTarget to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
