//
//  TokenScopeSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 21/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class TokenScopeSpecs: QuickSpec {

    override class func spec() {
        describe("TokenScope") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(TokenScope.annotationEdit).to(equal(TokenScope(TokenScope.annotationEdit.description)))
                    expect(TokenScope.annotationViewAll).to(equal(TokenScope(TokenScope.annotationViewAll.description)))
                    expect(TokenScope.annotationViewSelf).to(equal(TokenScope(TokenScope.annotationViewSelf.description)))
                    expect(TokenScope.baseExplorer).to(equal(TokenScope(TokenScope.baseExplorer.description)))
                    expect(TokenScope.basePicker).to(equal(TokenScope(TokenScope.basePicker.description)))
                    expect(TokenScope.basePreview).to(equal(TokenScope(TokenScope.basePreview.description)))
                    expect(TokenScope.baseSidebar).to(equal(TokenScope(TokenScope.baseSidebar.description)))
                    expect(TokenScope.baseUpload).to(equal(TokenScope(TokenScope.baseUpload.description)))
                    expect(TokenScope.itemDelete).to(equal(TokenScope(TokenScope.itemDelete.description)))
                    expect(TokenScope.itemDownload).to(equal(TokenScope(TokenScope.itemDownload.description)))
                    expect(TokenScope.itemPreview).to(equal(TokenScope(TokenScope.itemPreview.description)))
                    expect(TokenScope.itemRename).to(equal(TokenScope(TokenScope.itemRename.description)))
                    expect(TokenScope.itemShare).to(equal(TokenScope(TokenScope.itemShare.description)))
                    expect(TokenScope.itemUpload).to(equal(TokenScope(TokenScope.itemUpload.description)))
                    expect(TokenScope.customValue("custom value")).to(equal(TokenScope("custom value")))
                }
            }
        }
    }
}
