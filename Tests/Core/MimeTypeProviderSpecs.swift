//
//  MimeTypeProviderSpecs.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 08/07/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import Quick

class MimeTypeProviderSpecs: QuickSpec {
    override class func spec() {
        describe("MimeTypeProvider") {

            describe("getMimeTypeFrom()") {
                it("should return correct mime type from file name") {
                    expect(MimeTypeProvider.getMimeTypeFrom(filename: "test.png")).to(equal("image/png"))
                    expect(MimeTypeProvider.getMimeTypeFrom(filename: "test.jpg")).to(equal("image/jpeg"))
                    expect(MimeTypeProvider.getMimeTypeFrom(filename: "test.jpeg")).to(equal("image/jpeg"))
                    expect(MimeTypeProvider.getMimeTypeFrom(filename: "test.pdf")).to(equal("application/pdf"))
                    expect(MimeTypeProvider.getMimeTypeFrom(filename: "test.zip")).to(equal("application/zip"))
                }
            }
        }
    }
}
