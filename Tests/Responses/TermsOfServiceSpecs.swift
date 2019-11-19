
//
//  TermsOfServiceSpecs.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/21/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

@testable import BoxSDK
import Nimble
import Quick

class TermsOfServiceSpecs: QuickSpec {

    override func spec() {
        describe("TermsOfService") {
            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullTermsOfService", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let tos = try TermsOfService(json: jsonDict)

                        expect(tos.type).to(equal("terms_of_service"))
                        expect(tos.id).to(equal("12345"))
                        expect(tos.status).to(equal(.enabled))
                        expect(tos.tosType).to(equal(.managed))
                        expect(tos.createdAt?.iso8601).to(equal("2019-08-18T20:55:09Z"))
                        expect(tos.modifiedAt?.iso8601).to(equal("2019-08-18T20:55:09Z"))
                        expect(tos.enterprise?.id).to(equal("55555"))
                        expect(tos.enterprise?.type).to(equal("enterprise"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
