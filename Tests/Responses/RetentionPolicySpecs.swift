//
//  RetentionPolicySpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/25/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class RetentionPolicySpecs: QuickSpec {

    override func spec() {
        describe("Retention Policy") {

            describe("init()") {

                it("should correctly deserialize retention policy from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullRetentionPolicy", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let retentionPolicy = try RetentionPolicy(json: jsonDict)

                        expect(retentionPolicy.type).to(equal("retention_policy"))
                        expect(retentionPolicy.id).to(equal("123456789"))
                        expect(retentionPolicy.name).to(equal("Tax Documents"))
                        expect(retentionPolicy.policyType?.description).to(equal("finite"))
                        expect(retentionPolicy.retentionLength).to(equal(10))
                        expect(retentionPolicy.dispositionAction?.description).to(equal("remove_retention"))
                        expect(retentionPolicy.status?.description).to(equal("active"))
                        expect(retentionPolicy.createdBy?.type).to(equal("user"))
                        expect(retentionPolicy.createdBy?.id).to(equal("33333"))
                        expect(retentionPolicy.createdBy?.name).to(equal("Creator User"))
                        expect(retentionPolicy.createdBy?.login).to(equal("creator@example.com"))
                        expect(retentionPolicy.customNotificationRecipients?[0].type).to(equal("user"))
                        expect(retentionPolicy.customNotificationRecipients?[0].id).to(equal("22222"))
                        expect(retentionPolicy.customNotificationRecipients?[0].name).to(equal("Example User"))
                        expect(retentionPolicy.customNotificationRecipients?[0].login).to(equal("user@example.com"))
                        expect(retentionPolicy.createdAt?.iso8601).to(equal("2015-05-01T18:12:54Z"))
                        expect(retentionPolicy.modifiedAt?.iso8601).to(equal("2015-06-08T18:11:50Z"))
                        expect(retentionPolicy.canOwnerExtendRetention).to(equal(false))
                        expect(retentionPolicy.areOwnersNotified).to(equal(true))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
