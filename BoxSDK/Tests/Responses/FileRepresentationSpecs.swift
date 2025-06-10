//
//  FileRepresentationSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 23/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class FileRepresentationSpecs: QuickSpec {

    override class func spec() {
        describe("FileRepresentation") {

            describe("init") {

                it("should correctly decode a file representation type from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "FileRepresentationState.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let fileRepresentation: FileRepresentation = try BoxJSONDecoder.decode(json: jsonDict)

                        expect(fileRepresentation.status?.state).to(equal(.success))
                        expect(fileRepresentation.representation).to(equal("jpg"))
                        expect(fileRepresentation.properties.count).to(equal(3))
                        expect(fileRepresentation.content?.urlTemplate).to(equal("https://dl.boxcloud.com/api/2.0/internal_files/12345/versions/11111/representations/jpg_thumb_320x320/content/{+asset_path}"))
                        expect(fileRepresentation.info?.url).to(equal("https://api.box.com/2.0/internal_files/12345/versions/11111/representations/jpg_thumb_320x320"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }

        describe("FileRepresentation.StatusEnum") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(FileRepresentation.StatusEnum.none).to(equal(FileRepresentation.StatusEnum(FileRepresentation.StatusEnum.none.description)))
                    expect(FileRepresentation.StatusEnum.pending).to(equal(FileRepresentation.StatusEnum(FileRepresentation.StatusEnum.pending.description)))
                    expect(FileRepresentation.StatusEnum.viewable).to(equal(FileRepresentation.StatusEnum(FileRepresentation.StatusEnum.viewable.description)))
                    expect(FileRepresentation.StatusEnum.success).to(equal(FileRepresentation.StatusEnum(FileRepresentation.StatusEnum.success.description)))
                    expect(FileRepresentation.StatusEnum.error).to(equal(FileRepresentation.StatusEnum(FileRepresentation.StatusEnum.error.description)))
                    expect(FileRepresentation.StatusEnum.customValue("custom value")).to(equal(FileRepresentation.StatusEnum("custom value")))
                }
            }
        }

        describe("FileRepresentationHint") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(FileRepresentationHint.pdf).to(equal(FileRepresentationHint(FileRepresentationHint.pdf.description)))
                    expect(FileRepresentationHint.thumbnail).to(equal(FileRepresentationHint(FileRepresentationHint.thumbnail.description)))
                    expect(FileRepresentationHint.imageMedium).to(equal(FileRepresentationHint(FileRepresentationHint.imageMedium.description)))
                    expect(FileRepresentationHint.imageLarge).to(equal(FileRepresentationHint(FileRepresentationHint.imageLarge.description)))
                    expect(FileRepresentationHint.extractedText).to(equal(FileRepresentationHint(FileRepresentationHint.extractedText.description)))
                    expect(FileRepresentationHint.customValue("custom value")).to(equal(FileRepresentationHint("custom value")))
                }
            }
        }
    }
}
