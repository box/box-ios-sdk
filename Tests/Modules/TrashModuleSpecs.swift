//
//  TrashModuleSpecs.swift
//  BoxSDK
//
//  Created by Daniel Cech on 30/07/2019.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class TrashModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        describe("Trash Module") {
            beforeEach {
                self.sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("listItems()") {

                it("should make API call to get trashed items using offset iterator when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/folders/trash/items")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetTrashedItems.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.listItems { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(firstItem):
                                        guard case let .file(file) = firstItem else {
                                            fail("listItems returned invalid first item type")
                                            done()
                                            return
                                        }

                                        expect(file).to(beAKindOf(File.self))
                                        expect(file.id).to(equal("2701979016"))
                                        expect(file.name).to(equal("file Tue Jul 24 145436 2012KWPX5S.csv"))
                                        expect(file.etag).to(equal("1"))
                                        expect(file.sequenceId).to(equal("1"))
                                        expect(file.type).to(equal("file"))
                                    case let .failure(error):
                                        fail("Expected call to listItems to suceeded, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Expected call to listItems to suceeded, but instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            describe("getFile()") {

                it("should make API call to get trashed file and produce file response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/files/5859258256/trash")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetTrashedFile.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.getFile(id: "5859258256") { result in
                            switch result {
                            case let .success(file):
                                expect(file).to(beAKindOf(File.self))
                                expect(file.id).to(equal("5859258256"))
                                expect(file.name).to(equal("Screenshot_1_30_13_6_37_PM.png"))
                                expect(file.etag).to(equal("2"))
                                expect(file.sequenceId).to(equal("2"))
                                expect(file.type).to(equal("file"))

                            case let .failure(error):
                                fail("Expected call to getFile to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("getFolder()") {

                it("should make API call to get trashed folder and produce folder response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/folders/11446498/trash")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetTrashedFolder.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.getFolder(id: "11446498") { result in
                            switch result {
                            case let .success(folder):
                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.id).to(equal("11446498"))
                                expect(folder.name).to(equal("Pictures"))
                                expect(folder.etag).to(equal("1"))
                                expect(folder.sequenceId).to(equal("1"))
                                expect(folder.type).to(equal("folder"))

                            case let .failure(error):
                                fail("Expected call to getFolder to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("getWebLink()") {

                it("should make API call to get trashed web link and produce web link response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/web_links/6742981/trash")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetTrashedWebLink.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.getWebLink(id: "6742981") { result in
                            switch result {
                            case let .success(webLink):
                                expect(webLink).to(beAKindOf(WebLink.self))
                                expect(webLink.id).to(equal("33333"))
                                expect(webLink.name).to(equal("Test Website"))
                                expect(webLink.etag).to(equal("0"))
                                expect(webLink.sequenceId).to(equal("0"))
                                expect(webLink.type).to(equal("web_link"))

                            case let .failure(error):
                                fail("Expected call to getWebLink to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("restoreFile()") {

                it("should make API call to restore folder item and produce folder item response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/files/123456")
                            && isMethodPOST()
                            && hasJsonBody([
                                "name": "non-conflicting-name.jpg",
                                "parent": ["id": "14"]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("RestoreFile.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.restoreFile(
                            id: "123456",
                            name: "non-conflicting-name.jpg",
                            parentFolderId: "14"
                        ) { result in
                            switch result {
                            case let .success(file):
                                expect(file).to(beAKindOf(File.self))
                                expect(file.id).to(equal("11111"))
                                expect(file.name).to(equal("testfile.pdf"))
                                expect(file.etag).to(equal("2"))
                                expect(file.sequenceId).to(equal("2"))
                                expect(file.type).to(equal("file"))

                            case let .failure(error):
                                fail("Expected call to restoreFile to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("restoreFolder()") {

                it("should make API call to restore folder item and produce folder item response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/folders/11446498")
                            && isMethodPOST()
                            && hasJsonBody([
                                "name": "non-conflicting-name",
                                "parent": ["id": "14"]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("RestoreFolder.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.restoreFolder(
                            id: "11446498",
                            name: "non-conflicting-name",
                            parentFolderId: "14"
                        ) { result in
                            switch result {
                            case let .success(folder):
                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.id).to(equal("11111"))
                                expect(folder.name).to(equal("Test"))
                                expect(folder.etag).to(equal("1"))
                                expect(folder.sequenceId).to(equal("1"))
                                expect(folder.type).to(equal("folder"))

                            case let .failure(error):
                                fail("Expected call to restoreFolder to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("restoreWebLink()") {

                it("should make API call to restore web link and produce web link item response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/web_links/6742981")
                            && isMethodPOST()
                            && hasJsonBody([
                                "name": "non-conflicting-name",
                                "parent": ["id": "14"]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("RestoreWebLink.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.restoreWebLink(
                            id: "6742981",
                            name: "non-conflicting-name",
                            parentFolderId: "14"
                        ) { result in
                            switch result {
                            case let .success(webLink):
                                expect(webLink).to(beAKindOf(WebLink.self))
                                expect(webLink.id).to(equal("6742981"))
                                expect(webLink.name).to(equal("Test Website"))
                                expect(webLink.etag).to(equal("0"))
                                expect(webLink.sequenceId).to(equal("0"))
                                expect(webLink.type).to(equal("web_link"))

                            case let .failure(error):
                                fail("Expected call to restoreWebLink to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("permanentlyDeleteFile()") {

                it("should make API call to permanently delete file") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/files/123456/trash")
                            && isMethodDELETE()
                    ) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.permanentlyDeleteFile(id: "123456") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to permanentlyDeleteFile to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("permanentlyDeleteFolder()") {

                it("should make API call to permanently delete folder") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/folders/123456/trash")
                            && isMethodDELETE()
                    ) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.permanentlyDeleteFolder(id: "123456") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to permanentlyDeleteFolder to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("permanentlyDeleteWebLink()") {

                it("should make API call to permanently delete web link") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/web_links/123456/trash")
                            && isMethodDELETE()
                    ) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.trash.permanentlyDeleteWebLink(id: "123456") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to permanentlyDeleteWebLink to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }
        }
    }
}
