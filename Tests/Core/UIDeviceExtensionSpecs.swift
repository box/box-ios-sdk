//
//  UIDeviceExtensionSpecs.swift
//  BoxSDK
//
//  Created by Albert Wu on 9/9/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import Quick

class UIDeviceExtensionSpecs: QuickSpec {
    override func spec() {
        describe("UIDevice modelName") {

            it("should compute correctly for test simulator") {
                let sut = UIDevice.current

                expect(sut.modelName == "iPhone Simulator").to(equal(true))
            }
        }
    }
}
