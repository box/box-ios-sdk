//
//  FileRequestsModuleSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 09/08/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class FileRequestsModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        describe("FileRequestsModule") {
            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("get()") {
                it("should make API call to get file request response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/file_requests/42037322")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFileRequest.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.fileRequests.get(fileRequestId: "42037322") { result in
                            switch result {
                            case let .success(fileRequest):
                                expect(fileRequest.type).to(equal("file_request"))
                                expect(fileRequest.id).to(equal("42037322"))
                                expect(fileRequest.title).to(equal("Please upload documents"))
                                expect(fileRequest.description).to(equal("Following documents are requested for your process"))
                                expect(fileRequest.status).to(equal(.active))
                                expect(fileRequest.isEmailRequired).to(equal(true))
                                expect(fileRequest.isDescriptionRequired).to(equal(true))
                                expect(fileRequest.expiresAt?.iso8601).to(equal("2020-09-28T18:53:43Z"))
                                expect(fileRequest.url).to(equal("/f/19e57f40ace247278a8e3d336678c64a"))
                                expect(fileRequest.etag).to(equal("1"))
                                expect(fileRequest.createdAt.iso8601).to(equal("2020-09-28T18:53:43Z"))
                                expect(fileRequest.createdBy?.type).to(equal("user"))
                                expect(fileRequest.createdBy?.id).to(equal("11446498"))
                                expect(fileRequest.createdBy?.name).to(equal("Aaron Levie"))
                                expect(fileRequest.createdBy?.login).to(equal("ceo@example.com"))
                                expect(fileRequest.updatedAt.iso8601).to(equal("2020-09-28T18:53:43Z"))
                                expect(fileRequest.updatedBy?.type).to(equal("user"))
                                expect(fileRequest.updatedBy?.id).to(equal("11446498"))
                                expect(fileRequest.updatedBy?.name).to(equal("Aaron Levie"))
                                expect(fileRequest.updatedBy?.login).to(equal("ceo@example.com"))
                                expect(fileRequest.folder.id).to(equal("12345"))
                                expect(fileRequest.folder.etag).to(equal("1"))
                                expect(fileRequest.folder.type).to(equal("folder"))
                                expect(fileRequest.folder.sequenceId).to(equal("3"))
                                expect(fileRequest.folder.name).to(equal("Contracts"))
                            case let .failure(error):
                                fail("Unable to get sign request instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("update()") {
                it("should make API call to update a file request when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com") && isPath("/2.0/file_requests/42037322")
                            && isMethodPUT()
                            && hasJsonBody([
                                "title": "Updated title",
                                "description": "Updated description",
                                "status": "inactive",
                                "is_email_required": false,
                                "is_description_required": false,
                                "expires_at": "2020-09-28T20:53:43Z"

                            ])
                            && hasHeaderNamed("If-Match", value: "1")
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateFileRequest.json")!,
                            statusCode: 200, headers: [:]
                        )
                    }

                    let updateRequest = FileRequestUpdateRequest(
                        title: "Updated title",
                        description: "Updated description",
                        status: .inactive,
                        isEmailRequired: false,
                        isDescriptionRequired: false,
                        expiresAt: "2020-09-28T20:53:43Z".iso8601
                    )

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.fileRequests.update(
                            fileRequestId: "42037322",
                            ifMatch: "1",
                            updateRequest: updateRequest
                        ) { result in
                            switch result {
                            case let .success(fileRequest):
                                expect(fileRequest.type).to(equal("file_request"))
                                expect(fileRequest.id).to(equal("42037322"))
                                expect(fileRequest.title).to(equal("Updated title"))
                                expect(fileRequest.description).to(equal("Updated description"))
                                expect(fileRequest.status).to(equal(.inactive))
                                expect(fileRequest.isEmailRequired).to(equal(false))
                                expect(fileRequest.isDescriptionRequired).to(equal(false))
                                expect(fileRequest.expiresAt?.iso8601).to(equal("2020-09-28T20:53:43Z"))
                                expect(fileRequest.url).to(equal("/f/19e57f40ace247278a8e3d336678c64a"))
                                expect(fileRequest.etag).to(equal("1"))
                                expect(fileRequest.createdAt.iso8601).to(equal("2020-09-28T18:53:43Z"))
                                expect(fileRequest.createdBy?.type).to(equal("user"))
                                expect(fileRequest.createdBy?.id).to(equal("11446498"))
                                expect(fileRequest.createdBy?.name).to(equal("Aaron Levie"))
                                expect(fileRequest.createdBy?.login).to(equal("ceo@example.com"))
                                expect(fileRequest.updatedAt.iso8601).to(equal("2020-09-28T19:53:43Z"))
                                expect(fileRequest.updatedBy?.type).to(equal("user"))
                                expect(fileRequest.updatedBy?.id).to(equal("11446498"))
                                expect(fileRequest.updatedBy?.name).to(equal("Aaron Levie"))
                                expect(fileRequest.updatedBy?.login).to(equal("ceo@example.com"))
                                expect(fileRequest.folder.id).to(equal("12345"))
                                expect(fileRequest.folder.etag).to(equal("1"))
                                expect(fileRequest.folder.type).to(equal("folder"))
                                expect(fileRequest.folder.sequenceId).to(equal("3"))
                                expect(fileRequest.folder.name).to(equal("Contracts"))
                            case let .failure(error):
                                fail("Expected call to update to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("copy()") {
                it("should make API call to copy a file request when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com") && isPath("/2.0/file_requests/42037322/copy")
                            && isMethodPOST()
                            && hasJsonBody([
                                "title": "New title after copy",
                                "description": "New description after copy",
                                "is_email_required": true,
                                "is_description_required": false,
                                "expires_at": "2020-09-29T21:42:37Z",
                                "folder": ["id": "56789", "type": "folder"]

                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CopyFileRequest.json")!,
                            statusCode: 200, headers: [:]
                        )
                    }

                    let copyRequest = FileRequestCopyRequest(
                        title: "New title after copy",
                        description: "New description after copy",
                        isEmailRequired: true,
                        isDescriptionRequired: false,
                        expiresAt: "2020-09-29T21:42:37Z".iso8601,
                        folder: .init(id: "56789")
                    )

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.fileRequests.copy(fileRequestId: "42037322", copyRequest: copyRequest) { result in
                            switch result {
                            case let .success(fileRequest):
                                expect(fileRequest.type).to(equal("file_request"))
                                expect(fileRequest.id).to(equal("51183371"))
                                expect(fileRequest.title).to(equal("New title after copy"))
                                expect(fileRequest.description).to(equal("New description after copy"))
                                expect(fileRequest.status).to(equal(.active))
                                expect(fileRequest.isEmailRequired).to(equal(true))
                                expect(fileRequest.isDescriptionRequired).to(equal(false))
                                expect(fileRequest.expiresAt?.iso8601).to(equal("2020-09-29T21:42:37Z"))
                                expect(fileRequest.url).to(equal("/f/19e57f40ace247278a8e3d336678c64a"))
                                expect(fileRequest.etag).to(equal("1"))
                                expect(fileRequest.createdAt.iso8601).to(equal("2020-09-28T19:22:33Z"))
                                expect(fileRequest.createdBy?.type).to(equal("user"))
                                expect(fileRequest.createdBy?.id).to(equal("11446498"))
                                expect(fileRequest.createdBy?.name).to(equal("Aaron Levie"))
                                expect(fileRequest.createdBy?.login).to(equal("ceo@example.com"))
                                expect(fileRequest.updatedAt.iso8601).to(equal("2020-09-28T19:22:33Z"))
                                expect(fileRequest.updatedBy?.type).to(equal("user"))
                                expect(fileRequest.updatedBy?.id).to(equal("11446498"))
                                expect(fileRequest.updatedBy?.name).to(equal("Aaron Levie"))
                                expect(fileRequest.updatedBy?.login).to(equal("ceo@example.com"))
                                expect(fileRequest.folder.id).to(equal("56789"))
                                expect(fileRequest.folder.etag).to(equal("1"))
                                expect(fileRequest.folder.type).to(equal("folder"))
                                expect(fileRequest.folder.sequenceId).to(equal("1"))
                                expect(fileRequest.folder.name).to(equal("New Contracts"))
                            case let .failure(error):
                                fail("Expected call to update to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete()") {
                it("should make API call to delete file request response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/file_requests/42037322")
                            && isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.fileRequests.delete(fileRequestId: "42037322") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
