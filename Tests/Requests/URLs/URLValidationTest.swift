//
//  URLValidationTest.swift
//  BoxSDKTests-iOS
//
//  Created by Martina Stremeňová on 8/23/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import Quick

class URLValidationTest: QuickSpec {

    public override func spec() {

        describe("validate()") {
            it("should validate url and validation should not throw an error") {
                let validURLs: [URL] = [
                    URL(string: "https://google.com")!,
                    URL(string: "https://www.google.com")!,
                    URL(string: "https://validurl.com")!,
                    URL(string: "https://api.box.com")!
                ]
                validURLs.forEach { url in
                    expect { try URLValidation.validate(networkUrl: url) }.toNot(throwError())
                }
            }

            it("should validate url and validation should throw an error") {
                let invalidURLs: [URL] = [
                    URL(string: "https:///google.com")!,
                    URL(string: "http://www.google.com")!
                ]

                invalidURLs.forEach { url in
                    do {
                        try URLValidation.validate(networkUrl: url)
                    }
                    catch {
                        guard let boxError = error as? BoxSDKError else {
                            fail("Expected invalid url error, but cought different error \(error.localizedDescription)")
                            return
                        }
                        expect(boxError.message.description).to(equal("Invalid URL: \(url.absoluteString)"))
                    }
                }
            }
        }
    }
}
