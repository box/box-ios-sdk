//
//  FolderModuleSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class FolderModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {

        describe("Folders Module") {
            beforeEach {
                self.sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("create()") {
                it("should make API call to create folder and produce folder model when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/folders")
                            && isMethodPOST()
                            && hasJsonBody([
                                "name": "Pictures",
                                "parent": [
                                    "id": BoxSDK.Constants.rootFolder
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateFolder.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.create(name: "Pictures", parentId: BoxSDK.Constants.rootFolder) { result in
                            switch result {
                            case let .success(folder):
                                expect(folder).toNot(beNil())
                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.id).to(equal("11111"))
                                expect(folder.name).to(equal("Pictures"))
                                expect(folder.etag).to(equal("1"))
                                expect(folder.sequenceId).to(equal("1"))
                                expect(folder.type).to(equal("folder"))
                            case let .failure(error):
                                fail("Expected call to create to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should produce error when API call fails") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders") && isMethodPOST()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateFolder.json", type(of: self))!,
                            statusCode: 409, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.create(name: "Pictures", parentId: BoxSDK.Constants.rootFolder) { result in
                            switch result {
                            case .success:
                                fail("Expected call to create to suceeded, but it failed")
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                            }
                            done()
                        }
                    }
                }
            }

            describe("listItems()") {

                it("should get folder items using offset pagination iterator when usemarker flag is not set") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET() && containsQueryParams(["offset": "0"])) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFolderItemsOffsetIterator1.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET() && containsQueryParams(["offset": "2"])) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFolderItemsOffsetIterator2.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in

                        self.sut.folders.listItems(folderId: BoxSDK.Constants.rootFolder, usemarker: false, offset: 0, limit: 2, direction: .ascending, fields: ["name", "url", "description"]) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(firstItem):
                                        guard case let .folder(folder) = firstItem else {
                                            fail("Unable to get folder items")
                                            done()
                                            return
                                        }
                                        expect(folder).to(beAKindOf(Folder.self))
                                        expect(folder.id).to(equal("11111"))
                                        expect(folder.name).to(equal("TestFolder"))
                                        expect(folder.etag).to(equal("0"))
                                        expect(folder.sequenceId).to(equal("0"))

                                    case let .failure(error):
                                        fail("Unable to get folder items: \(error)")
                                    }
                                    done()
                                }

                            case let .failure(error):
                                fail("Unable to get folder items: \(error)")
                                done()
                            }
                        }
                    }
                }

                it("should get folder items using marker pagination iterator when usemarker flag is set") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET() && containsQueryParams(["marker": "eyJ0eXBlIjoiZm9sZGVyIiwiZGlyIjoibmV4dCIsInRhaWwiOiJleUoxYzJWeVgybGtJam8zTlRBeU5UUTNPRGd5TENKd1lYSmxiblJmWm05c1pHVnlYMmxrSWpvd0xDSmtaV3hsZEdWa0lqb3dMQ0ptYjJ4a1pYSmZibUZ0WlNJNklrMTVJRUp2ZUNCT2IzUmxjeUlzSW1admJHUmxjbDlwWkNJNk5qa3hNREk1TURRNE5UVjkifQ"])) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFolderItemsMarkerIterator2.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET() && !containsQueryParams(["marker": "eyJ0eXBlIjoiZm9sZGVyIiwiZGlyIjoibmV4dCIsInRhaWwiOiJleUoxYzJWeVgybGtJam8zTlRBeU5UUTNPRGd5TENKd1lYSmxiblJmWm05c1pHVnlYMmxrSWpvd0xDSmtaV3hsZEdWa0lqb3dMQ0ptYjJ4a1pYSmZibUZ0WlNJNklrMTVJRUp2ZUNCT2IzUmxjeUlzSW1admJHUmxjbDlwWkNJNk5qa3hNREk1TURRNE5UVjkifQ"]) && !containsQueryParams(["offset": "2"])) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFolderItemsMarkerIterator1.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in

                        self.sut.folders.listItems(folderId: BoxSDK.Constants.rootFolder, usemarker: true, offset: 0, limit: 2, direction: .ascending, fields: ["name", "url", "description"]) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(firstItem):
                                        guard case let .folder(folder) = firstItem else {
                                            fail("Unable to get folder items")
                                            done()
                                            return
                                        }

                                        expect(folder).to(beAKindOf(Folder.self))
                                        expect(folder.id).to(equal("69102302893"))
                                        expect(folder.name).to(equal("TestFolder"))
                                        expect(folder.etag).to(equal("0"))
                                        expect(folder.sequenceId).to(equal("0"))

                                    case let .failure(error):
                                        fail("Unable to get folder items: \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get folder items: \(error)")
                                done()
                            }
                        }
                    }
                }

                it("should produce error when API call fails") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFolderItems.json", type(of: self))!,
                            statusCode: 404, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in

                        self.sut.folders.listItems(folderId: BoxSDK.Constants.rootFolder, usemarker: false, offset: 0, limit: 2, direction: .ascending, fields: ["name", "url", "description"]) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    default:
                                        fail("Expected call to get folder items to fail, but it suceeded")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                                done()
                            }
                        }
                    }
                }
            }

            describe("delete()") {

                it("should delete the folder") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/1234567") && isMethodDELETE()) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.delete(folderId: "1234567") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to createFolder to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should delete the folder and contents when recursive parameter is true") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/1234567") && isMethodDELETE() && containsQueryParams(["recursive": "true"])) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.delete(folderId: "1234567", recursive: true) { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should not delete folder contents when recursive parameter is set to false") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/1234567") && isMethodDELETE() && containsQueryParams(["recursive": "false"])) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.delete(folderId: "1234567", recursive: false) { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should produce error when the API call fails") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/1231231") && isMethodDELETE()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFolderItems.json", type(of: self))!,
                            statusCode: 404, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.delete(folderId: "1231231", recursive: true) { response in
                            switch response {
                            case .success:
                                fail("Expected call to delete folder to fail, but it suceeded")
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                            }
                            done()
                        }
                    }
                }
            }

            describe("copy()") {
                it("should copy the folder in the destinated folder") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/11446498/copy") && isMethodPOST() && self.compareJSONBody(["parent": ["id": "123456"], "name": "Pictures copy"])) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CopyFolder.json", type(of: self))!,
                            statusCode: 202, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10.0) { done in
                        self.sut.folders.copy(folderId: "11446498", destinationFolderID: "123456", name: "Pictures copy") { result in
                            switch result {
                            case let .success(folder):
                                expect(folder).toNot(beNil())
                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.id).to(equal("11111"))
                                expect(folder.name).to(equal("Pictures copy"))
                                expect(folder.etag).to(equal("1"))
                                expect(folder.sequenceId).to(equal("1"))
                                expect(folder.type).to(equal("folder"))
                                expect(folder.parent).to(beAKindOf(Folder.self))
                                expect(folder.parent?.id).to(equal("123456"))
                                expect(folder.itemStatus).to(equal(.active))
                                expect(folder.folderUploadEmail).to(beAKindOf(FolderUploadEmail.self))
                                expect(folder.folderUploadEmail?.access).to(equal("open"))
                                expect(folder.folderUploadEmail?.email).to(equal("upload.Picture.k13sdz1@u.box.com"))
                            case let .failure(error):
                                fail("Expected call to suceeded, but it failed and got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listCollaborations ") {
                it("should get folder collaborations") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/14176246/collaborations") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("FolderCollaborations.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.listCollaborations(folderId: "14176246") { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(item):
                                        expect(item).to(beAKindOf(Collaboration.self))
                                        expect(item.id).to(equal("11111"))
                                        expect(item.createdBy).to(beAKindOf(User.self))
                                        expect(item.createdBy?.id).to(equal("22222"))
                                        expect(item.createdBy?.name).to(equal("Test User"))

                                    case let .failure(error):
                                        fail("Expected listCollaborations, but it failed: \(error)")
                                    }
                                    done()
                                }

                            case let .failure(error):
                                fail("Expected listCollaborations, but it failed: \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            describe("addToFavorites()") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collections")
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetCollections.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFolderInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodPUT()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("AddFolderToFavorites.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should make API call to add folder to favorites") {
                    waitUntil(timeout: 10) { done in
                        self.sut.folders.addToFavorites(folderId: "5000948880", completion: { result in
                            switch result {
                            case let .success(folder):
                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.type).to(equal("folder"))
                            case let .failure(error):
                                fail("Expected call to addToFavorites to suceeded, but it failed \(error)")
                            }
                            done()
                        })
                    }
                }
            }

            describe("removeFromFavorites()") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collections")
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetCollections.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFolderInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodPUT()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("RemoveFolderFromFavorites.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should make API call to remove folder from favorites") {
                    waitUntil(timeout: 10) { done in
                        self.sut.folders.removeFromFavorites(folderId: "5000948880", completion: { result in
                            switch result {
                            case let .success(folder):
                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.type).to(equal("folder"))
                            case let .failure(error):
                                fail("Expected call to removeFromFavorites to suceeded, but it failed \(error)")
                            }
                            done()
                        })
                    }
                }
            }

            describe("getSharedLink()") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodGET() &&
                            containsQueryParams(["fields": "shared_link"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFolderSharedLink.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }

                it("should download a shared link for a folder", closure: {
                    waitUntil(timeout: 10) { done in
                        self.sut.folders.getSharedLink(forFolder: "5000948880") { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).toNot(beNil())
                            case let .failure(error):
                                fail("Expected call to getSharedLink to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                })
            }

            describe("setSharedLink()") {

                context("updating folder with new password value") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/folders/5000948880") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open", "password": "frog"]])
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetFolderSharedLink.json", type(of: self))!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a folder", closure: {
                        waitUntil(timeout: 10) { done in
                            self.sut.folders.setSharedLink(forFolder: "5000948880", access: SharedLinkAccess.open, password: .value("frog")) { result in
                                switch result {
                                case let .success(sharedLink):
                                    expect(sharedLink.access).to(equal(.open))
                                    expect(sharedLink.previewCount).to(equal(0))
                                    expect(sharedLink.downloadCount).to(equal(0))
                                    expect(sharedLink.downloadURL).to(beNil())
                                    expect(sharedLink.isPasswordEnabled).to(equal(true))
                                case let .failure(error):
                                    fail("Expected call to createOrUpdateSharedLink to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    })
                }

                context("updating folder without updating password") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/folders/5000948880") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open"]])
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetFolderSharedLink.json", type(of: self))!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a folder", closure: {
                        waitUntil(timeout: 10) { done in
                            self.sut.folders.setSharedLink(forFolder: "5000948880", access: SharedLinkAccess.open) { result in
                                switch result {
                                case let .success(sharedLink):
                                    expect(sharedLink.access).to(equal(.open))
                                    expect(sharedLink.previewCount).to(equal(0))
                                    expect(sharedLink.downloadCount).to(equal(0))
                                    expect(sharedLink.downloadURL).to(beNil())
                                    expect(sharedLink.isPasswordEnabled).to(equal(true))
                                case let .failure(error):
                                    fail("Expected call to createOrUpdateSharedLink to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    })
                }

                context("updating folder with password deletion") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/folders/5000948880") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open", "password": NSNull()]])
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetFolderSharedLink_PasswordNotEnabled.json", type(of: self))!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a folder", closure: {
                        waitUntil(timeout: 10) { done in
                            self.sut.folders.setSharedLink(forFolder: "5000948880", access: SharedLinkAccess.open, password: .null) { result in
                                switch result {
                                case let .success(sharedLink):
                                    expect(sharedLink.access).to(equal(.open))
                                    expect(sharedLink.previewCount).to(equal(0))
                                    expect(sharedLink.downloadCount).to(equal(0))
                                    expect(sharedLink.downloadURL).to(beNil())
                                    expect(sharedLink.isPasswordEnabled).to(equal(false))
                                case let .failure(error):
                                    fail("Expected call to createOrUpdateSharedLink to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    })
                }
            }

            describe("deleteSharedLink()") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodPUT() &&
                            hasJsonBody(["shared_link": NSNull()])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("RemoveFolderSharedLink.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should delete a shared link for a folder", closure: {
                    waitUntil(timeout: 10) { done in
                        self.sut.folders.deleteSharedLink(forFolder: "5000948880") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to deleteSharedLink to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                })
            }

            describe("getWatermark()") {
                it("should make API call to get a folder's watermark") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/folders/12345/watermark")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("FullWatermark.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.getWatermark(folderId: "12345") { result in
                            switch result {
                            case let .success(watermark):
                                expect(watermark).toNot(beNil())
                                expect(watermark.createdAt?.iso8601).to(equal("2019-08-27T00:55:33Z"))
                                expect(watermark.modifiedAt?.iso8601).to(equal("2019-08-27T01:55:33Z"))
                            case let .failure(error):
                                fail("Expected call to getWatermark to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("applyWatermark()") {
                it("should make API call to apply a watermark on a folder") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/folders/12345/watermark")
                            && isMethodPUT()
                            && hasJsonBody([
                                Watermark.resourceKey: [
                                    Watermark.imprintKey: Watermark.defaultImprint
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("FullWatermark.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.applyWatermark(folderId: "12345") { result in
                            switch result {
                            case let .success(watermark):
                                expect(watermark).toNot(beNil())
                                expect(watermark.createdAt?.iso8601).to(equal("2019-08-27T00:55:33Z"))
                                expect(watermark.modifiedAt?.iso8601).to(equal("2019-08-27T01:55:33Z"))
                            case let .failure(error):
                                fail("Expected call to applyrWatermark to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("removeWatermark()") {
                it("should remove the watermark from folder") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/12345/watermark") && isMethodDELETE()) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.folders.removeWatermark(folderId: "12345") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to removeWatermark to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
