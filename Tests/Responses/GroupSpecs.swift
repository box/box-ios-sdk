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

class GroupSpecs: QuickSpec {

    override func spec() {
        describe("Group") {
            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullGroup", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let group = try Group(json: jsonDict)

                        expect(group.type).to(equal("group"))
                        expect(group.id).to(equal("11111"))
                        expect(group.name).to(equal("Team A"))
                        expect(group.groupType).to(equal(.managedGroup))
                        expect(group.createdAt?.iso8601).to(equal("2016-11-17T05:47:04Z"))
                        expect(group.modifiedAt?.iso8601).to(equal("2019-06-18T20:28:44Z"))
                        expect(group.provenance).to(equal("IDP"))
                        expect(group.description).to(equal("Team A from IDP"))
                        expect(group.externalSyncIdentifier).to(equal("idp-team-a"))
                        expect(group.invitabilityLevel).to(equal(.allManagedUsers))
                        expect(group.memberViewabilityLevel).to(equal(.allManagedUsers))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
