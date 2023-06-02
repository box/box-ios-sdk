//
//  SharedLinkDataSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 21/06/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SharedLinkDataSpecs: QuickSpec {

    override class func spec() {
        describe("SharedLinkData") {

            context("init") {

                it("should correctly create an object using init with all parameters") {
                    let sut = SharedLinkData(
                        access: .open,
                        password: .value("password123"),
                        unsharedAt: .value("2019-05-28T19:12:46Z".iso8601!),
                        vanityName: .value("vanity_name_123"),
                        canDownload: true,
                        canEdit: true
                    )

                    expect(sut.access).to(equal(.open))
                    expect(sut.password).to(equal(.value("password123")))
                    expect(sut.unsharedAt).to(equal(.value("2019-05-28T19:12:46Z".iso8601!)))
                    expect(sut.vanityName).to(equal(.value("vanity_name_123")))
                    expect(sut.permissions).to(equal(["can_download": true, "can_edit": true]))
                }

                it("should correctly create an object using init with access parameter only") {
                    let sut = SharedLinkData(
                        access: .open
                    )

                    expect(sut.access).to(equal(.open))
                    expect(sut.password).to(beNil())
                    expect(sut.unsharedAt).to(beNil())
                    expect(sut.vanityName).to(beNil())
                    expect(sut.permissions).to(beNil())
                }
            }

            context("copyWithoutPermissions") {

                it("should correctly copy an object using when excluded 1 permission from 2") {
                    let source = SharedLinkData(
                        access: .open,
                        password: .value("password123"),
                        unsharedAt: .value("2019-05-28T19:12:46Z".iso8601!),
                        vanityName: .value("vanity_name_123"),
                        canDownload: true,
                        canEdit: true
                    )

                    let sut = source.copyWithoutPermissions(["can_edit"])

                    expect(sut.access).to(equal(source.access))
                    expect(sut.password).to(equal(source.password))
                    expect(sut.unsharedAt).to(equal(.value("2019-05-28T19:12:46Z".iso8601!)))
                    expect(sut.vanityName).to(equal(source.vanityName))
                    expect(sut.permissions).to(equal(["can_download": true]))
                }

                it("should correctly copy an object using when excluded  2 permission from 2 available") {
                    let source = SharedLinkData(
                        access: .open,
                        password: .value("password123"),
                        unsharedAt: .value("2019-05-28T19:12:46Z".iso8601!),
                        vanityName: .value("vanity_name_123"),
                        canDownload: true,
                        canEdit: true
                    )

                    let sut = source.copyWithoutPermissions(["can_edit", "can_download"])

                    expect(sut.access).to(equal(source.access))
                    expect(sut.password).to(equal(source.password))
                    expect(sut.unsharedAt).to(equal(source.unsharedAt))
                    expect(sut.vanityName).to(equal(source.vanityName))
                    expect(sut.permissions).to(beNil())
                }

                it("should correctly copy an object using when excluded 2 permission from 0 available") {
                    let source = SharedLinkData(
                        access: .open,
                        password: .value("password123"),
                        unsharedAt: .value("2019-05-28T19:12:46Z".iso8601!),
                        vanityName: .value("vanity_name_123")
                    )

                    let sut = source.copyWithoutPermissions(["can_edit", "can_download"])

                    expect(sut.access).to(equal(source.access))
                    expect(sut.password).to(equal(source.password))
                    expect(sut.unsharedAt).to(equal(source.unsharedAt))
                    expect(sut.vanityName).to(equal(source.vanityName))
                    expect(sut.permissions).to(beNil())
                }
            }
        }
    }
}
