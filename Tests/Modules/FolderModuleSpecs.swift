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

    override class func spec() {
        var sut: BoxClient!

        describe("Folders Module") {
            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateFolder.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.create(name: "Pictures", parentId: BoxSDK.Constants.rootFolder) { result in
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateFolder.json")!,
                            statusCode: 409, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.create(name: "Pictures", parentId: BoxSDK.Constants.rootFolder) { result in
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

            describe("update()") {
                it("should not send can_edit sharedLink permission") {
                    stub(condition: isHost("api.box.com")
                        && isPath("/2.0/folders/11111")
                        && isMethodPUT()
                        && containsQueryParams(["fields": "name,shared_link"])
                        && hasJsonBody([
                            "shared_link": [
                                "access": "open",
                                "permissions": ["can_download": true]
                            ]
                        ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.update(
                            folderId: "11111",
                            sharedLink: .value(SharedLinkData(access: .open, canDownload: true, canEdit: true)),
                            fields: ["name", "shared_link"]
                        ) { result in
                            switch result {
                            case let .success(folder):
                                expect(folder).toNot(beNil())
                                expect(folder).to(beAKindOf(Folder.self))
                                expect(folder.id).to(equal("11111"))
                                expect(folder.name).to(equal("Pictures"))
                                expect(folder.etag).to(equal("1"))
                                expect(folder.sequenceId).to(equal("1"))
                                expect(folder.type).to(equal("folder"))
                                expect(folder.sharedLink).toNot(beNil())
                                expect(folder.sharedLink?.access).to(equal(.open))
                                expect(folder.sharedLink?.permissions?.canDownload).to(equal(true))
                                expect(folder.sharedLink?.permissions?.canEdit).to(equal(false))
                            case let .failure(error):
                                fail("Expected call to update to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listItems()") {

                it("should get folder items using offset pagination iterator when usemarker flag is not set") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET() && containsQueryParams(["offset": "0"])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderItemsOffsetIterator1.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET() && containsQueryParams(["offset": "2"])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderItemsOffsetIterator2.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in

                        let iterator = sut.folders.listItems(folderId: BoxSDK.Constants.rootFolder, usemarker: false, offset: 0, limit: 2, direction: .ascending, fields: ["name", "url", "description"])
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let firstItem = page.entries[0]
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

                                let secondItem = page.entries[1]
                                guard case let .webLink(webLink) = secondItem else {
                                    fail("Unable to get folder items")
                                    done()
                                    return
                                }

                                expect(webLink).to(beAKindOf(WebLink.self))
                                expect(webLink.id).to(equal("11111"))
                                expect(webLink.name).to(equal("Example Web Link"))
                                expect(webLink.etag).to(equal("0"))
                                expect(webLink.sequenceId).to(equal("0"))
                                expect(webLink.url).to(equal(URL(string: "http://example.com")))

                            case let .failure(error):
                                fail("Unable to get folder items: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should get folder items using marker pagination iterator when usemarker flag is set") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET() && containsQueryParams(["marker": "eyJ0eXBlIjoiZm9sZGVyIiwiZGlyIjoibmV4dCIsInRhaWwiOiJleUoxYzJWeVgybGtJam8zTlRBeU5UUTNPRGd5TENKd1lYSmxiblJmWm05c1pHVnlYMmxrSWpvd0xDSmtaV3hsZEdWa0lqb3dMQ0ptYjJ4a1pYSmZibUZ0WlNJNklrMTVJRUp2ZUNCT2IzUmxjeUlzSW1admJHUmxjbDlwWkNJNk5qa3hNREk1TURRNE5UVjkifQ"])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderItemsMarkerIterator2.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET() && !containsQueryParams(["marker": "eyJ0eXBlIjoiZm9sZGVyIiwiZGlyIjoibmV4dCIsInRhaWwiOiJleUoxYzJWeVgybGtJam8zTlRBeU5UUTNPRGd5TENKd1lYSmxiblJmWm05c1pHVnlYMmxrSWpvd0xDSmtaV3hsZEdWa0lqb3dMQ0ptYjJ4a1pYSmZibUZ0WlNJNklrMTVJRUp2ZUNCT2IzUmxjeUlzSW1admJHUmxjbDlwWkNJNk5qa3hNREk1TURRNE5UVjkifQ"]) && !containsQueryParams(["offset": "2"])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderItemsMarkerIterator1.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in

                        let iterator = sut.folders.listItems(folderId: BoxSDK.Constants.rootFolder, usemarker: true, offset: 0, limit: 2, direction: .ascending, fields: ["name", "url", "description"])
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let firstItem = page.entries[0]
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
                    }
                }

                it("should produce error when API call fails") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/\(BoxSDK.Constants.rootFolder)/items") && isMethodGET()) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderItems.json")!,
                            statusCode: 404, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in

                        let iterator = sut.folders.listItems(folderId: BoxSDK.Constants.rootFolder, usemarker: false, offset: 0, limit: 2, direction: .ascending, fields: ["name", "url", "description"])
                        iterator.next { result in
                            switch result {
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                            default:
                                fail("Expected call to get folder items to fail, but it suceeded")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete()") {

                it("should delete the folder") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/1234567") && isMethodDELETE()) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.delete(folderId: "1234567") { response in
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
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.delete(folderId: "1234567", recursive: true) { response in
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
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.delete(folderId: "1234567", recursive: false) { response in
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderItems.json")!,
                            statusCode: 404, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.delete(folderId: "1231231", recursive: true) { response in
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CopyFolder.json")!,
                            statusCode: 202, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.copy(folderId: "11446498", destinationFolderID: "123456", name: "Pictures copy") { result in
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FolderCollaborations.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.folders.listCollaborations(folderId: "14176246")
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let item = page.entries[0]
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
                    }
                }
            }

            describe("addToFavorites()") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collections")
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollections.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodPUT()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "AddFolderToFavorites.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should make API call to add folder to favorites") {
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.addToFavorites(folderId: "5000948880", completion: { result in
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollections.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/folders/5000948880") &&
                            isMethodPUT()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "RemoveFolderFromFavorites.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should make API call to remove folder from favorites") {
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.removeFromFavorites(folderId: "5000948880", completion: { result in
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFolderSharedLink.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }

                it("should download a shared link for a folder", closure: {
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.getSharedLink(forFolder: "5000948880") { result in
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

                context("updating shared link and setting password to new value") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/folders/5000948880") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open", "password": "frog"]])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetFolderSharedLink.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a folder", closure: {
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.folders.setSharedLink(forFolder: "5000948880", access: SharedLinkAccess.open, password: .value("frog")) { result in
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

                context("updating shared link and setting vanity name to new value") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/folders/5000948880") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open", "vanity_name": "testVanityName"]])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetFolderSharedLink_VanityNameEnabled.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a folder", closure: {
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.folders.setSharedLink(forFolder: "5000948880", access: SharedLinkAccess.open, vanityName: .value("testVanityName")) { result in
                                switch result {
                                case let .success(sharedLink):
                                    expect(sharedLink.access).to(equal(.open))
                                    expect(sharedLink.previewCount).to(equal(0))
                                    expect(sharedLink.downloadCount).to(equal(0))
                                    expect(sharedLink.downloadURL).to(beNil())
                                    expect(sharedLink.isPasswordEnabled).to(equal(true))
                                    expect(sharedLink.url).to(equal(URL(string: "https://cloud.box.com/v/testVanityName")))
                                    expect(sharedLink.vanityName).to(equal("testVanityName"))
                                    expect(sharedLink.vanityURL).to(equal(URL(string: "https://cloud.box.com/v/testVanityName")))
                                case let .failure(error):
                                    fail("Expected call to createOrUpdateSharedLink to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    })
                }

                context("updating shared link permissions without updating password") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/folders/5000948880") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open", "permissions": ["can_download": true]]])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetFolderSharedLink.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a folder", closure: {
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.folders.setSharedLink(forFolder: "5000948880", access: SharedLinkAccess.open, canDownload: true) { result in
                                switch result {
                                case let .success(sharedLink):
                                    expect(sharedLink.access).to(equal(.open))
                                    expect(sharedLink.previewCount).to(equal(0))
                                    expect(sharedLink.downloadCount).to(equal(0))
                                    expect(sharedLink.downloadURL).to(beNil())
                                    expect(sharedLink.isPasswordEnabled).to(equal(true))
                                    expect(sharedLink.permissions?.canDownload).to(equal(true))
                                    expect(sharedLink.permissions?.canPreview).to(equal(true))
                                    expect(sharedLink.permissions?.canEdit).to(equal(false))
                                case let .failure(error):
                                    fail("Expected call to createOrUpdateSharedLink to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    })
                }

                context("updating shared link and deleting the password") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/folders/5000948880") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open", "password": NSNull()]])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetFolderSharedLink_PasswordNotEnabled.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a folder", closure: {
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.folders.setSharedLink(forFolder: "5000948880", access: SharedLinkAccess.open, password: .null) { result in
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "RemoveFolderSharedLink.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should delete a shared link for a folder", closure: {
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.deleteSharedLink(forFolder: "5000948880") { result in
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullWatermark.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.getWatermark(folderId: "12345") { result in
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
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullWatermark.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.applyWatermark(folderId: "12345") { result in
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
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.removeWatermark(folderId: "12345") { response in
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

            describe("listLocks()") {
                it("should get folder locks") {
                    stub(
                        condition: isHost("api.box.com") && isPath("/2.0/folder_locks") && isMethodGET() &&
                            containsQueryParams(["folder_id": "14176246"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FolderLocks.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.folders.listLocks(folderId: "14176246")
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let item = page.entries[0]
                                expect(item).to(beAKindOf(FolderLock.self))
                                expect(item.id).to(equal("12345678"))
                                expect(item.createdBy).to(beAKindOf(User.self))
                                expect(item.createdBy?.id).to(equal("11446498"))
                                expect(item.lockType).to(equal("freeze"))

                            case let .failure(error):
                                fail("Expected folder locks, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("createLock()") {
                it("should create a folder lock") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/folder_locks")
                            && isMethodPOST()
                            && hasJsonBody([
                                "folder": [
                                    "type": "folder",
                                    "id": "14176246"
                                ],
                                "locked_operations": [
                                    "move": true,
                                    "delete": true
                                ]
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FolderLock.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.createLock(folderId: "14176246") { result in
                            switch result {
                            case let .success(folderLock):
                                expect(folderLock).toNot(beNil())
                                expect(folderLock).to(beAKindOf(FolderLock.self))
                                expect(folderLock.lockType).to(equal("freeze"))
                            case let .failure(error):
                                fail("Expected call to create to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("deleteLock()") {
                it("should delete the lock") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folder_locks/1234567") && isMethodDELETE()) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.folders.deleteLock(folderLockId: "1234567") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to deleteLock to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("FolderUploadEmailAccess") {

                describe("init()") {

                    it("should correctly create an enum value from it's string representation") {
                        expect(FolderUploadEmailAccess.open).to(equal(FolderUploadEmailAccess(FolderUploadEmailAccess.open.description)))
                        expect(FolderUploadEmailAccess.collaborators).to(equal(FolderUploadEmailAccess(FolderUploadEmailAccess.collaborators.description)))
                        expect(FolderUploadEmailAccess.customValue("custom value")).to(equal(FolderUploadEmailAccess("custom value")))
                    }
                }
            }

            describe("FolderItemsOrderBy") {

                describe("init()") {

                    it("should correctly create an enum value from it's string representation") {
                        expect(FolderItemsOrderBy.id).to(equal(FolderItemsOrderBy(FolderItemsOrderBy.id.description)))
                        expect(FolderItemsOrderBy.name).to(equal(FolderItemsOrderBy(FolderItemsOrderBy.name.description)))
                        expect(FolderItemsOrderBy.date).to(equal(FolderItemsOrderBy(FolderItemsOrderBy.date.description)))
                        expect(FolderItemsOrderBy.type).to(equal(FolderItemsOrderBy(FolderItemsOrderBy.type.description)))
                        expect(FolderItemsOrderBy.customValue("custom value")).to(equal(FolderItemsOrderBy("custom value")))
                    }
                }
            }
        }
    }
}
