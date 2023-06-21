//
//  CollaborationsModuleSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 6/4/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class CollaborationsModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        describe("CollaborationsModule") {
            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("get()") {
                it("should retreive collaboration with id") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaborations/791293") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollaboration.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborations.get(collaborationId: "791293") { result in
                            switch result {
                            case let .success(collaboration):
                                expect(collaboration.type).to(equal("collaboration"))
                                expect(collaboration.id).to(equal("11111"))
                                expect(collaboration.createdBy?.id).to(equal("22222"))
                                expect(collaboration.createdBy?.login).to(equal("testuser@example.com"))
                                expect(collaboration.createdBy?.name).to(equal("Test User"))
                                expect(collaboration.role?.description).to(equal("editor"))
                                expect(collaboration.status?.description).to(equal("accepted"))
                                guard case let .folder(folder)? = collaboration.item else {
                                    fail("Expected that the item is a folder and instead receive other object type")
                                    done()
                                    return
                                }

                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.id).to(equal("22222"))
                                expect(folder.name).to(equal("Shared Pictures"))
                                expect(folder.etag).to(equal("0"))
                                expect(folder.sequenceId).to(equal("0"))
                            case let .failure(error):
                                fail("Expected call to get to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("create()") {

                context("case when updating canViewPath parameter") {
                    it("should create collaboration") {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/collaborations") &&
                                isMethodPOST() &&
                                self.compareJSONBody(["item": ["id": "11446500", "type": "folder"], "accessible_by": ["id": "123456", "type": "group"], "role": "editor", "can_view_path": true])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetCollaboration.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.collaborations.create(itemType: "folder", itemId: "11446500", role: .editor, accessibleBy: "123456", accessibleByType: .group, canViewPath: true) { result in
                                switch result {
                                case let .success(collaboration):
                                    expect(collaboration.type).to(equal("collaboration"))
                                    expect(collaboration.id).to(equal("11111"))
                                    expect(collaboration.createdBy?.id).to(equal("22222"))
                                    expect(collaboration.createdBy?.login).to(equal("testuser@example.com"))
                                    expect(collaboration.createdBy?.name).to(equal("Test User"))
                                    expect(collaboration.role?.description).to(equal("editor"))
                                    guard case let .folder(folder)? = collaboration.item else {
                                        fail("Expected that the item is a folder and instead receive other object type")
                                        done()
                                        return
                                    }

                                    expect(folder).to(beAKindOf(Folder.self))
                                    expect(folder.id).to(equal("22222"))
                                    expect(folder.name).to(equal("Shared Pictures"))
                                    expect(folder.etag).to(equal("0"))
                                    expect(folder.sequenceId).to(equal("0"))
                                case let .failure(error):
                                    fail("Expected call to create to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("case when user did not specify canViewPath parameter") {
                    it("should create collaboration") {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/collaborations") &&
                                isMethodPOST() &&
                                self.compareJSONBody(["item": ["id": "11446500", "type": "folder"], "accessible_by": ["id": "123456", "type": "group"], "role": "editor"])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetCollaboration.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.collaborations.create(itemType: "folder", itemId: "11446500", role: .editor, accessibleBy: "123456", accessibleByType: .group) { result in
                                switch result {
                                case let .success(collaboration):
                                    expect(collaboration.type).to(equal("collaboration"))
                                    expect(collaboration.id).to(equal("11111"))
                                    expect(collaboration.createdBy?.id).to(equal("22222"))
                                    expect(collaboration.createdBy?.login).to(equal("testuser@example.com"))
                                    expect(collaboration.createdBy?.name).to(equal("Test User"))
                                    expect(collaboration.role?.description).to(equal("editor"))
                                    guard case let .folder(folder)? = collaboration.item else {
                                        fail("Expected that the item is a folder and instead receive other object type")
                                        done()
                                        return
                                    }

                                    expect(folder).to(beAKindOf(Folder.self))
                                    expect(folder.id).to(equal("22222"))
                                    expect(folder.name).to(equal("Shared Pictures"))
                                    expect(folder.etag).to(equal("0"))
                                    expect(folder.sequenceId).to(equal("0"))
                                case let .failure(error):
                                    fail("Expected call to create to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }
            }

            describe("createByUserEmail()") {
                it("should create collaboration") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaborations") &&
                            isMethodPOST() &&
                            self.compareJSONBody(["item": ["id": "11446500", "type": "folder"], "accessible_by": ["login": "testuser@example.com", "type": "user"], "role": "editor"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollaboration.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborations.createByUserEmail(itemType: "folder", itemId: "11446500", role: .editor, login: "testuser@example.com") { result in
                            switch result {
                            case let .success(collaboration):
                                expect(collaboration.type).to(equal("collaboration"))
                                expect(collaboration.id).to(equal("11111"))
                                expect(collaboration.createdBy?.id).to(equal("22222"))
                                expect(collaboration.createdBy?.login).to(equal("testuser@example.com"))
                                expect(collaboration.createdBy?.name).to(equal("Test User"))
                                expect(collaboration.role?.description).to(equal("editor"))
                                guard case let .folder(folder)? = collaboration.item else {
                                    fail("Expected that the item is a folder and instead receive other object type")
                                    done()
                                    return
                                }

                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.id).to(equal("22222"))
                                expect(folder.name).to(equal("Shared Pictures"))
                                expect(folder.etag).to(equal("0"))
                                expect(folder.sequenceId).to(equal("0"))
                            case let .failure(error):
                                fail("Expected call to create to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                context("case when user did not specify canViewPath parameter") {
                    it("should create collaboration") {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/collaborations") &&
                                isMethodPOST() &&
                                self.compareJSONBody(["item": ["id": "11446500", "type": "folder"], "accessible_by": ["id": "123456", "type": "group"], "role": "editor"])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetCollaboration.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.collaborations.create(itemType: "folder", itemId: "11446500", role: .editor, accessibleBy: "123456", accessibleByType: .group) { result in
                                switch result {
                                case let .success(collaboration):
                                    expect(collaboration.type).to(equal("collaboration"))
                                    expect(collaboration.id).to(equal("11111"))
                                    expect(collaboration.createdBy?.id).to(equal("22222"))
                                    expect(collaboration.createdBy?.login).to(equal("testuser@example.com"))
                                    expect(collaboration.createdBy?.name).to(equal("Test User"))
                                    expect(collaboration.role?.description).to(equal("editor"))
                                    guard case let .folder(folder)? = collaboration.item else {
                                        fail("Expected that the item is a folder and instead receive other object type")
                                        done()
                                        return
                                    }

                                    expect(folder).to(beAKindOf(Folder.self))
                                    expect(folder.id).to(equal("22222"))
                                    expect(folder.name).to(equal("Shared Pictures"))
                                    expect(folder.etag).to(equal("0"))
                                    expect(folder.sequenceId).to(equal("0"))
                                case let .failure(error):
                                    fail("Expected call to create to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }
            }

            describe("update()") {
                it("should update collaboration") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaborations/791293") &&
                            isMethodPUT() &&
                            self.compareJSONBody(["role": "viewer"])

                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateCollaboration.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborations.update(collaborationId: "791293", role: .viewer) { result in
                            switch result {
                            case let .success(collaboration):
                                expect(collaboration.type).to(equal("collaboration"))
                                expect(collaboration.id).to(equal("11111"))
                                expect(collaboration.createdBy?.id).to(equal("22222"))
                                expect(collaboration.createdBy?.login).to(equal("testuser@example.com"))
                                expect(collaboration.createdBy?.name).to(equal("Test User"))
                                expect(collaboration.role?.description).to(equal("viewer"))
                                guard case let .folder(folder)? = collaboration.item else {
                                    fail("Expected that the item is a folder and instead receive other object type")
                                    done()
                                    return
                                }

                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.id).to(equal("33333"))
                                expect(folder.name).to(equal("Shared Pictures"))
                                expect(folder.etag).to(equal("0"))
                                expect(folder.sequenceId).to(equal("0"))
                            case let .failure(error):
                                fail("Expected call to update to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getAcceptanceRequirementsStatus()") {
                it("should retrieve acceptance requirements status for collaboration") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaborations/12345") &&
                            isMethodGET() &&
                            containsQueryParams(["fields": "acceptance_requirements_status"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullCollaboration.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborations.getAcceptanceRequirementsStatus(collaborationId: "12345") { result in
                            switch result {
                            case let .success(acceptanceRequirement):
                                expect(acceptanceRequirement).toNot(beNil())
                                expect(acceptanceRequirement.termsOfServiceRequirement.isAccepted).to(beTrue())
                            case let .failure(error):
                                fail("Expected call to getAcceptanceRequirementsStatus to suceed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete()") {
                it("should delete collaboration") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaborations/123456") &&
                            isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collaborations.delete(collaborationId: "123456") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listPendingForEnterprise()") {
                it("should get pending collaborations") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collaborations") &&
                            isMethodGET() &&
                            containsQueryParams(["status": "pending", "offset": "0", "limit": "2"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "PendingCollaborations.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.collaborations.listPendingForEnterprise(offset: 0, limit: 2)
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let firstItem = page.entries[0]
                                expect(firstItem.type).to(equal("collaboration"))
                                expect(firstItem.id).to(equal("11111"))
                                expect(firstItem.createdBy?.id).to(equal("22222"))
                                expect(firstItem.createdBy?.login).to(equal("testuser@example.com"))
                                expect(firstItem.createdBy?.name).to(equal("Test User"))
                                expect(firstItem.role?.description).to(equal("editor"))

                                guard let collaborator = firstItem.accessibleBy?.collaboratorValue, case let .user(user) = collaborator else {
                                    fail("Unable to unwrap expected user value")
                                    done()
                                    return
                                }
                                expect(user.id).to(equal("22222"))
                                expect(user.login).to(equal("testuser@example.com"))
                                expect(user.name).to(equal("Test User"))

                            case let .failure(error):
                                fail("Unable to get pending collaborations instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            context("AccessibleBy") {

                describe("init()") {

                    it("should correctly create an enum value from it's string representation") {
                        expect(AccessibleBy.user).to(equal(AccessibleBy(AccessibleBy.user.description)))
                        expect(AccessibleBy.group).to(equal(AccessibleBy(AccessibleBy.group.description)))
                        expect(AccessibleBy.customValue("custom value")).to(equal(AccessibleBy("custom value")))
                    }
                }
            }
        }
    }
}
