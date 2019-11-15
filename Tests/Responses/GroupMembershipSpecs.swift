//
//  GroupSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/18/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class GroupMembershipSpecs: QuickSpec {

    override func spec() {
        describe("GroupMembership") {
            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullGroupMembership", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let groupMembership = try GroupMembership(json: jsonDict)

                        expect(groupMembership.type).to(equal("group_membership"))
                        expect(groupMembership.id).to(equal("12345"))
                        expect(groupMembership.user?.type).to(equal("user"))
                        expect(groupMembership.user?.id).to(equal("54321"))
                        expect(groupMembership.user?.name).to(equal("Test User"))
                        expect(groupMembership.user?.login).to(equal("testuser@example.com"))
                        expect(groupMembership.group?.type).to(equal("group"))
                        expect(groupMembership.group?.id).to(equal("11111"))
                        expect(groupMembership.group?.name).to(equal("Test"))
                        expect(groupMembership.role).to(equal(.admin))
                        expect(groupMembership.configurablePermissions?.canRunReports).to(equal(true))
                        expect(groupMembership.configurablePermissions?.canInstantLogin).to(equal(true))
                        expect(groupMembership.configurablePermissions?.canCreateAccounts).to(equal(false))
                        expect(groupMembership.configurablePermissions?.canEditAccounts).to(equal(true))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
