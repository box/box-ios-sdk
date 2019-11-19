//
//  UserSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/17/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class UserSpecs: QuickSpec {

    override func spec() {
        describe("User") {

            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullUser", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let user = try User(json: jsonDict)

                        expect(user.type).to(equal("user"))
                        expect(user.id).to(equal("22222"))
                        expect(user.name).to(equal("Example User"))
                        expect(user.login).to(equal("user@example.com"))
                        expect(user.createdAt?.iso8601).to(equal("2012-06-07T18:14:50Z"))
                        expect(user.modifiedAt?.iso8601).to(equal("2019-06-17T22:30:56Z"))
                        expect(user.role).to(equal("user"))
                        expect(user.language).to(equal("en"))
                        expect(user.timezone).to(equal("America/Los_Angeles"))
                        expect(user.spaceAmount).to(equal(1_000_000_000_000_000))
                        expect(user.spaceUsed).to(equal(18_236_190_421))
                        expect(user.maxUploadSize).to(equal(34_359_738_368))
                        expect(user.trackingCodes?.count).to(equal(1))
                        expect(user.trackingCodes?[0].name).to(equal("foo"))
                        expect(user.trackingCodes?[0].value).to(equal("bar"))
                        expect(user.canSeeManagedUsers).to(beTrue())
                        expect(user.isSyncEnabled).to(beTrue())
                        expect(user.status).to(equal(.active))
                        expect(user.jobTitle).to(equal("Software Engineer"))
                        expect(user.phone).to(equal("5555555555"))
                        expect(user.address).to(equal("900 Jefferson Ave"))
                        expect(user.avatarUrl?.absoluteString).to(equal("https://cloud.app.box.com/api/avatar/large/22222"))
                        expect(user.isExemptFromDeviceLimits).to(beFalse())
                        expect(user.isExemptFromLoginVerification).to(beFalse())
                        expect(user.enterprise?.type).to(equal("enterprise"))
                        expect(user.enterprise?.id).to(equal("12345"))
                        expect(user.enterprise?.name).to(equal("Box Enterprise"))
                        expect(user.myTags?.count).to(equal(1))
                        expect(user.myTags?[0]).to(equal("foo"))
                        expect(user.hostname).to(equal("https://cloud.app.box.com/"))
                        expect(user.isExternalCollabRestricted).to(beFalse())
                        expect(user.isPlatformAccessOnly).to(beFalse())
                        expect(user.externalAppUserId).to(beNil())
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
