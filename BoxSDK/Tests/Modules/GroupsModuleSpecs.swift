//
//  GroupsModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 9/5/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class GroupsModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        describe("Groups Module") {

            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("get()") {
                it("should make API call to retrieve a group when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/groups/11111")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullGroup.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.groups.get(groupId: "11111") { result in
                            switch result {
                            case let .success(group):
                                expect(group).toNot(beNil())
                                expect(group.type).to(equal("group"))
                                expect(group.name).to(equal("Team A"))
                                expect(group.description).to(equal("Team A from IDP"))
                                expect(group.invitabilityLevel).to(equal(.allManagedUsers))
                                expect(group.memberViewabilityLevel).to(equal(.allManagedUsers))
                            case let .failure(error):
                                fail("Expected call to get to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("create()") {
                it("should make API call to create group when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/groups")
                            && isMethodPOST()
                            && hasJsonBody([
                                "name": "Team A",
                                "provenance": "IDP",
                                "external_sync_identifier": "idp-team-a",
                                "description": "Team A from IDP",
                                "invitability_level": "all_managed_users",
                                "member_viewability_level": "all_managed_users"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullGroup.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.groups.create(name: "Team A", provenance: "IDP", externalSyncIdentifier: "idp-team-a", description: "Team A from IDP", invitabilityLevel: .allManagedUsers, memberViewabilityLevel: .allManagedUsers) { result in
                            switch result {
                            case let .success(group):
                                expect(group).toNot(beNil())
                                expect(group.type).to(equal("group"))
                                expect(group.name).to(equal("Team A"))
                                expect(group.description).to(equal("Team A from IDP"))
                                expect(group.invitabilityLevel).to(equal(.allManagedUsers))
                                expect(group.memberViewabilityLevel).to(equal(.allManagedUsers))
                            case let .failure(error):
                                fail("Expected call to create to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("update()") {
                it("should make API call to update group when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/groups/11111")
                            && isMethodPUT()
                            && hasJsonBody([
                                "name": "Team A",
                                "provenance": "IDP",
                                "external_sync_identifier": "idp-team-a",
                                "description": "Team A from IDP",
                                "invitability_level": "all_managed_users",
                                "member_viewability_level": "all_managed_users"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullGroup.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.groups.update(groupId: "11111", name: "Team A", provenance: .value("IDP"), externalSyncIdentifier: .value("idp-team-a"), description: .value("Team A from IDP"), invitabilityLevel: .allManagedUsers, memberViewabilityLevel: .allManagedUsers) { result in
                            switch result {
                            case let .success(group):
                                expect(group).toNot(beNil())
                                expect(group.type).to(equal("group"))
                                expect(group.name).to(equal("Team A"))
                                expect(group.description).to(equal("Team A from IDP"))
                                expect(group.invitabilityLevel).to(equal(.allManagedUsers))
                                expect(group.memberViewabilityLevel).to(equal(.allManagedUsers))
                            case let .failure(error):
                                fail("Expected call to update to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete()") {

                it("should make API call to delete the specified group") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/groups/11111") && isMethodDELETE()) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.groups.delete(groupId: "11111") { response in
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

            describe("getMembershipInfo()") {
                it("should make API call to retrieve a group membership when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/group_memberships/12345")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullGroupMembership.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.groups.getMembershipInfo(membershipId: "12345") { result in
                            switch result {
                            case let .success(membership):
                                expect(membership).toNot(beNil())
                                expect(membership.type).to(equal("group_membership"))
                                expect(membership.id).to(equal("12345"))
                                expect(membership.role).to(equal(.admin))
                                expect(membership.configurablePermissions?.canRunReports).to(equal(true))
                                expect(membership.configurablePermissions?.canCreateAccounts).to(equal(false))

                            case let .failure(error):
                                fail("Expected call to getMembershipInfo to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("createMembership()") {
                it("should make API call to create a group membership when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/group_memberships")
                            && isMethodPOST()
                            && hasJsonBody([
                                "user": [
                                    "id": "54321"
                                ],
                                "group": [
                                    "id": "11111"
                                ],
                                "role": "admin",
                                "configurable_permissions": [
                                    "can_run_reports": true,
                                    "can_instant_login": true,
                                    "can_create_accounts": false,
                                    "can_edit_accounts": true
                                ]
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullGroupMembership.json")!,
                            statusCode: 201, headers: [:]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.groups.createMembership(userId: "54321", groupId: "11111", role: .admin, configurablePermission: .value(ConfigurablePermissionData(canRunReports: true, canInstantLogin: true, canCreateAccounts: false, canEditAccounts: true))) { result in
                            switch result {
                            case let .success(membership):
                                expect(membership).toNot(beNil())
                                expect(membership.type).to(equal("group_membership"))
                                expect(membership.id).to(equal("12345"))
                                expect(membership.role).to(equal(.admin))
                                expect(membership.configurablePermissions?.canRunReports).to(equal(true))
                                expect(membership.configurablePermissions?.canCreateAccounts).to(equal(false))
                            case let .failure(error):
                                fail("Expected call to createMembership to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("updateMembership()") {
                it("should make API call to update info of the group membership when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/group_memberships/12345")
                            && isMethodPUT()
                            && hasJsonBody([
                                "role": "admin",
                                "configurable_permissions": [
                                    "can_run_reports": true,
                                    "can_instant_login": true,
                                    "can_create_accounts": false,
                                    "can_edit_accounts": true
                                ]
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullGroupMembership.json")!,
                            statusCode: 200, headers: [:]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.groups.updateMembership(membershipId: "12345", role: .admin, configurablePermission: .value(ConfigurablePermissionData(canRunReports: true, canInstantLogin: true, canCreateAccounts: false, canEditAccounts: true))) { result in
                            switch result {
                            case let .success(membership):
                                expect(membership).toNot(beNil())
                                expect(membership.type).to(equal("group_membership"))
                                expect(membership.id).to(equal("12345"))
                                expect(membership.role).to(equal(.admin))
                                expect(membership.configurablePermissions?.canRunReports).to(equal(true))
                                expect(membership.configurablePermissions?.canCreateAccounts).to(equal(false))
                            case let .failure(error):
                                fail("Expected call to updateMembership to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("deleteMembership()") {

                it("should make API call to delete the specified group membership") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/group_memberships/12345") && isMethodDELETE()) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.groups.deleteMembership(membershipId: "12345") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to deleteMembership to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listMemberships()") {
                it("should be able to get memberships for the specified group") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/groups/12345/memberships")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetMembershipsForGroup.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.groups.listMemberships(groupId: "12345")
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let group = page.entries[0]
                                expect(group).toNot(beNil())
                                expect(group.id).to(equal("12345"))
                                expect(group.type).to(equal("group_membership"))

                            case let .failure(error):
                                fail("Unable to get memberships for the specified group instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listMembershipsForUser()") {
                it("should be able to get memberships for the specified user") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/users/12345/memberships")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetMembershipsForUser.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.groups.listMembershipsForUser(userId: "12345")
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let group = page.entries[0]
                                expect(group).toNot(beNil())
                                expect(group.id).to(equal("12345"))
                                expect(group.type).to(equal("group_membership"))
                                expect(group.user?.type).to(equal("user"))
                                expect(group.user?.id).to(equal("11111"))
                                expect(group.group?.id).to(equal("54321"))

                            case let .failure(error):
                                fail("Unable to get memberships for the specified user instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listCollaborations()") {
                it("should be able to get collaborations for the specified group") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/groups/12345/collaborations")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollaborationsForGroup.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.groups.listCollaborations(groupId: "12345")
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let collaboration = page.entries[0]
                                expect(collaboration).toNot(beNil())
                                expect(collaboration.id).to(equal("12345"))
                                expect(collaboration.type).to(equal("collaboration"))
                                expect(collaboration.role).to(equal(.viewer))

                            case let .failure(error):
                                fail("Unable to get collaborations for the specified group instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
