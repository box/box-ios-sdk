//
//  CollaborationSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/11/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class CollaborationSpecs: QuickSpec {

    override func spec() {
        describe("Collaboration") {

            describe("init()") {

                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullCollaboration", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let collaboration = try Collaboration(json: jsonDict)

                        expect(collaboration.type).to(equal("collaboration"))
                        expect(collaboration.id).to(equal("123456"))
                        expect(collaboration.createdBy?.type).to(equal("user"))
                        expect(collaboration.createdBy?.id).to(equal("11111"))
                        expect(collaboration.createdBy?.name).to(equal("Example User"))
                        expect(collaboration.createdBy?.login).to(equal("user@example.com"))
                        expect(collaboration.createdAt?.iso8601).to(equal("2019-02-08T21:19:51Z"))
                        expect(collaboration.modifiedAt?.iso8601).to(equal("2019-02-21T19:53:17Z"))
                        expect(collaboration.expiresAt).to(beNil())
                        expect(collaboration.status).to(equal(CollaborationStatus.accepted))

                        guard let collaborator = collaboration.accessibleBy?.collaboratorValue, case let .user(user) = collaborator else {
                            fail("Unable to unwrap expected collaborator")
                            return
                        }
                        expect(user.type).to(equal("user"))
                        expect(user.id).to(equal("22222"))
                        expect(user.name).to(equal("Example Collaborator"))
                        expect(user.login).to(equal("collaborator@example.com"))
                        expect(collaboration.inviteEmail).to(beNil())
                        expect(collaboration.role).to(equal(CollaborationRole.editor))
                        expect(collaboration.acknowledgedAt?.iso8601).to(equal("2019-02-08T21:19:51Z"))

                        guard let item = collaboration.item, case let .folder(folder) = item else {
                            fail("Expected folder item for collaboration")
                            return
                        }
                        expect(folder.type).to(equal("folder"))
                        expect(folder.id).to(equal("33333"))
                        expect(folder.sequenceId).to(equal("0"))
                        expect(folder.etag).to(equal("0"))
                        expect(folder.name).to(equal("Documents"))

                        expect(collaboration.canViewPath).to(beFalse())

                        guard let strongPasswordRequirement = collaboration.acceptanceRequirementsStatus?.strongPasswordRequirement else {
                            fail("Unable to unwrap expected strong password requirement")
                            return
                        }
                        expect(strongPasswordRequirement.strongPasswordRequiredForExternalUsers).to(beFalse())
                        expect(strongPasswordRequirement.userHasStrongPassword).to(beFalse())

                        guard let termsOfServiceRequirement = collaboration.acceptanceRequirementsStatus?.termsOfServiceRequirement else {
                            fail("Unable to unwrap expected terms of service requirement")
                            return
                        }
                        expect(termsOfServiceRequirement.isAccepted).to(beTrue())
                        expect(termsOfServiceRequirement.termsOfService.id).to(equal("12345"))
                        expect(termsOfServiceRequirement.termsOfService.type).to(equal("terms_of_service"))

                        guard let twoFactorRequirement = collaboration.acceptanceRequirementsStatus?.twoFactorAuthenticationRequirement else {
                            fail("Unable to unwrap expected two factor authentication requirement")
                            return
                        }
                        expect(twoFactorRequirement.enterpriseHasTwoFactorAuthEnabled).to(beFalse())
                        expect(twoFactorRequirement.userHasTwoFactorAuthenticationEnabled).to(beFalse())
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should correctly deserialize group collaboration from JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "GroupCollaboration", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let collaboration = try Collaboration(json: jsonDict)

                        expect(collaboration.type).to(equal("collaboration"))
                        expect(collaboration.id).to(equal("11111"))
                        expect(collaboration.createdAt?.iso8601).to(equal("2019-06-18T20:01:49Z"))
                        expect(collaboration.modifiedAt?.iso8601).to(equal("2019-06-18T20:01:49Z"))
                        expect(collaboration.expiresAt).to(beNil())
                        expect(collaboration.status).to(equal(CollaborationStatus.accepted))

                        guard let collaborator = collaboration.accessibleBy?.collaboratorValue, case let .group(group) = collaborator else {
                            fail("Unable to unwrap expected collaborator")
                            return
                        }
                        expect(group.type).to(equal("group"))
                        expect(group.id).to(equal("22222"))
                        expect(group.name).to(equal("Team A"))
                        expect(group.groupType).to(equal(.managedGroup))

                        expect(collaboration.inviteEmail).to(beNil())
                        expect(collaboration.role).to(equal(CollaborationRole.editor))
                        expect(collaboration.acknowledgedAt?.iso8601).to(equal("2019-06-18T20:01:49Z"))

                        guard let item = collaboration.item, case let .folder(folder) = item else {
                            fail("Expected folder item for collaboration")
                            return
                        }
                        expect(folder.type).to(equal("folder"))
                        expect(folder.id).to(equal("33333"))
                        expect(folder.sequenceId).to(equal("0"))
                        expect(folder.etag).to(equal("0"))
                        expect(folder.name).to(equal("Team A Folder"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
