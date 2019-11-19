//
//  FileVersionLegalHoldSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/5/19.
//  Copyright © 2019 box. All rights reserved.
//
@testable import BoxSDK
import Nimble
import Quick

class FileVersionLegalHoldSpecs: QuickSpec {

    override func spec() {
        describe("File Version Legal Hold") {

            describe("init()") {

                it("should correctly deserialize file version legal hold from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullFileVersionLegalHold", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let legalHold = try FileVersionLegalHold(json: jsonDict)

                        expect(legalHold.type).to(equal("legal_hold"))
                        expect(legalHold.id).to(equal("24097"))
                        expect(legalHold.fileVersion?.type).to(equal("file_version"))
                        expect(legalHold.fileVersion?.id).to(equal("14169417"))
                        expect(legalHold.file?.type).to(equal("file"))
                        expect(legalHold.file?.id).to(equal("502122933"))
                        expect(legalHold.file?.etag).to(equal("1"))
                        expect(legalHold.legalHoldPolicyAssignments?[0].type).to(equal("legal_hold_policy_assignment"))
                        expect(legalHold.legalHoldPolicyAssignments?[0].id).to(equal("25573"))
                        expect(legalHold.legalHoldPolicyAssignments?[1].type).to(equal("legal_hold_policy_assignment"))
                        expect(legalHold.legalHoldPolicyAssignments?[1].id).to(equal("25517"))
                        expect(legalHold.deletedAt).to(beNil())
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
