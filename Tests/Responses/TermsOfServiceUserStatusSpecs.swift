//
//  TermsOfServiceUserStatusSpecs.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/22/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

@testable import BoxSDK
import Nimble
import Quick

class TermsOfServiceUserStatusSpecs: QuickSpec {

    override func spec() {
        describe("TermsOfServiceUserStatus") {
            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullTermsOfServiceUserStatus", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let userStatus = try TermsOfServiceUserStatus(json: jsonDict)

                        expect(userStatus.type).to(equal("terms_of_service_user_status"))
                        expect(userStatus.id).to(equal("88888"))
                        expect(userStatus.tos?.type).to(equal("terms_of_service"))
                        expect(userStatus.tos?.id).to(equal("12345"))
                        expect(userStatus.user?.type).to(equal("user"))
                        expect(userStatus.user?.id).to(equal("11111"))
                        expect(userStatus.isAccepted).to(equal(true))
                        expect(userStatus.createdAt?.iso8601).to(equal("2019-08-18T20:55:09Z"))
                        expect(userStatus.modifiedAt?.iso8601).to(equal("2019-08-18T20:55:09Z"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
