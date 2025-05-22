//
//  CollaborationAllowlistModuleSpecs.swift
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

class CollaborationAllowlistModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        describe("CollaborationsAllowlistModule") {
            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("listEntries()") {
                it("should retrieve collaboration allowlist entries") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_entries") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollaborationWhitelistEntries.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.collaborationAllowList.listEntries()
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let firstItem = page.entries[0]
                                expect(firstItem).to(beAKindOf(CollaborationAllowlistEntry.self))
                                expect(firstItem.id).to(equal("123456"))
                                expect(firstItem.domain).to(equal("somedomain.com"))
                                expect(firstItem.direction).to(equal(.inbound))

                            case let .failure(error):
                                fail("Unable to get collaboration allowlist items: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("get()") {
                it("should retrieve collaboration allowlist entry with particular ID") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_entries/12345") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollaborationWhitelistEntryByID.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborationAllowList.get(id: "12345") { result in
                            switch result {
                            case let .success(entry):
                                expect(entry).to(beAKindOf(CollaborationAllowlistEntry.self))
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
                                fail("Unable to get collaboration allowlist item")
                            }

                            done()
                        }
                    }
                }
            }

            describe("create()") {
                it("should create collaboration allowlist entry") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_entries") &&
                            isMethodPOST() &&
                            hasJsonBody([
                                "direction": "both",
                                "domain": "example.com"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateCollaborationWhitelistEntry.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborationAllowList.create(
                            domain: "example.com",
                            direction: .both
                        ) { result in
                            switch result {
                            case let .success(entry):
                                expect(entry).to(beAKindOf(CollaborationAllowlistEntry.self))
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
                                fail("Unable to get collaboration allowlist item")
                            }

                            done()
                        }
                    }
                }
            }

            describe("delete()") {
                it("should delete collaboration allowlist entry") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_entries/12345") &&
                            isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborationAllowList.delete(id: "12345") { response in
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
                it("should retrieve collaboration allowlist exempt targets") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_exempt_targets") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollaborationWhitelistExemptUsers.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.collaborationAllowList.listExemptTargets()
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let firstTarget = page.entries[0]
                                expect(firstTarget).to(beAKindOf(CollaborationAllowlistExemptTarget.self))
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
                    }
                }
            }

            describe("getExemptTarget()") {
                it("should retrieve collaboration allowlist exempt target with particular ID") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_exempt_targets/12345") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollaborationWhitelistExemptUsersByID.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborationAllowList.getExemptTarget(id: "12345") { result in
                            switch result {
                            case let .success(target):
                                expect(target).to(beAKindOf(CollaborationAllowlistExemptTarget.self))
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
                                fail("Unable to get collaboration allowlist exempt target item")
                            }

                            done()
                        }
                    }
                }
            }

            describe("exemptUser()") {
                it("should create collaboration allowlist exempt target entry") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_exempt_targets") &&
                            isMethodPOST() &&
                            hasJsonBody(["user": ["id": "12345"]])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateCollaborationWhitelistExemptUser.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborationAllowList.exemptUser(
                            userId: "12345"
                        ) { result in
                            switch result {
                            case let .success(target):
                                expect(target).to(beAKindOf(CollaborationAllowlistExemptTarget.self))
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
                                fail("Unable to get collaboration allowlist exempt target item")
                            }

                            done()
                        }
                    }
                }
            }

            describe("deleteExemptTarget()") {
                it("should delete collaboration allowlist exempt target entry") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaboration_whitelist_exempt_targets/12345") &&
                            isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborationAllowList.deleteExemptTarget(id: "12345") { response in
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
