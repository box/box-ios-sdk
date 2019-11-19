//
//  BoxFileModulesSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/28/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class FilesModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        beforeEach {
            self.sut = BoxSDK.getClient(token: "asdads")
        }

        afterEach {
            OHHTTPStubs.removeAllStubs()
        }

        describe("FilesModule") {
            describe("get()") {
                it("should make API call to get file info and produce file model when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/5000948880") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.get(fileId: "5000948880") { result in
                            switch result {
                            case let .success(file):
                                expect(file).toNot(beNil())
                                expect(file.id).to(equal("5000948880"))
                                expect(file.name).to(equal("testfile.jpeg"))
                                expect(file.description).to(equal("Test File"))
                                expect(file.size).to(equal(629_644))
                                expect(file.createdBy).to(beAKindOf(User.self))
                                expect(file.createdBy?.name).to(equal("Test User"))
                                expect(file.createdBy?.login).to(equal("testuser@example.com"))
                                expect(file.createdBy?.id).to(equal("17738362"))
                            case let .failure(error):
                                fail("Expected call to get to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should produce error when API call fails") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/500094889") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileInfo.json", type(of: self))!,
                            statusCode: 404, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.get(fileId: "500094889") { result in
                            switch result {
                            case .success:
                                fail("Expected call to getFileInfo to fail, but it succeeded")
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                guard let apiError = error as? BoxAPIError else {
                                    fail("Expected API error")
                                    done()
                                    return
                                }

                                let bundle = Bundle(for: type(of: self))
                                // swiftlint:disable:next force_unwrap
                                let templatePath = bundle.url(forResource: "APIErrorTemplate", withExtension: "json")!.path
                                var errorNoStackTrace = apiError.getDictionary()
                                errorNoStackTrace["stackTrace"] = nil
                                let errorJSON = try! JSONSerialization.data(withJSONObject: errorNoStackTrace)
                                // This ensures the X-Box-UA header is not checked. This header will change based on simulator versions.
                                let checkClosure: CheckClosureType = { checkTuple in
                                    if let lastPathElement = checkTuple.path.last {
                                        if case let .string(stringID) = lastPathElement {
                                            if ["X-Box-UA"].contains(stringID) {
                                                return .equal
                                            }
                                        }
                                    }
                                    return .default
                                }

                                let match = JSONComparer.match(
                                    json1String: String(data: errorJSON, encoding: .utf8)!,
                                    json2String: try! String(contentsOfFile: templatePath),
                                    checkClosure: checkClosure
                                )
                                expect(match).to(beTrue())
                            }
                            done()
                        }
                    }
                }
            }

            describe("listRepresentations()") {
                it("should retrieve representations from a file") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/files/12345")
                            && containsQueryParams(["fields": "representations"])
                            && hasHeaderNamed("x-rep-hints", value: "[extracted_text]")
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetRepresentations.json", type(of: self))!,
                            statusCode: 200, headers: ["x-rep-hints": "[extracted_text]"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.listRepresentations(fileId: "12345", representationHint: .extractedText) { result in
                            switch result {
                            case let .success(representations):
                                guard let firstRepresentation = representations.first else {
                                    fail("Representation list should not be empty")
                                    done()
                                    return
                                }
                                expect(firstRepresentation.info?.url).to(equal("https://api.box.com/2.0/internal_files/12345/versions/11111/representations/extracted_text"))
                                expect(firstRepresentation.status?.state?.description).to(equal("success"))
                                expect(firstRepresentation.representation).to(equal("text"))

                                let properties = firstRepresentation.properties

                                expect(properties["paged"]).to(equal("false"))
                                expect(properties["thumb"]).to(equal("true"))

                            case let .failure(error):
                                fail("Expected call to listRepresentations() to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should retrieve representations from a file when no x-rep-hints are passed") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/files/12345")
                            && containsQueryParams(["fields": "representations"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetRepresentationsNoHeader.json", type(of: self))!,
                            statusCode: 200, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.listRepresentations(fileId: "12345") { result in
                            switch result {
                            case let .success(representations):
                                expect(representations[0].info?.url).to(equal("https://api.box.com/2.0/internal_files/12345/versions/11111/representations/jpg_thumb_32x32"))
                                expect(representations[1].info?.url).to(equal("https://api.box.com/2.0/internal_files/12345/versions/22222/representations/jpg_thumb_94x94"))
                            case let .failure(error):
                                fail("Expected call to listtRepresentations() to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getRepresentationContent()") {

                context("Download file representation on the provided destination folder") {

                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileURL = documentsURL.appendingPathComponent("doc.txt")

                    beforeEach {
                        try? FileManager.default.removeItem(at: fileURL.absoluteURL)
                    }

                    it("should be able to download a file representation if status is 'success'") {
                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/2.0/files/12345")
                                && containsQueryParams(["fields": "representations"])
                                && hasHeaderNamed("x-rep-hints", value: "[extracted_text]")
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetRepresentations.json", type(of: self))!,
                                statusCode: 200, headers: ["x-rep-hints": "[extracted_text]"]
                            )
                        }

                        stub(
                            condition: isHost("dl.boxcloud.com") && isPath("/api/2.0/internal_files/12345/versions/11111/representations/extracted_text/content")
                        ) { _ in
                            // swiftlint:disable:next force_unwrapping
                            OHHTTPStubsResponse(data: "Extracted text".data(using: .utf8)!, statusCode: 200, headers: [:])
                        }

                        waitUntil(timeout: 10) { done in

                            self.sut.files.getRepresentationContent(
                                fileId: "12345",
                                representationHint: .extractedText,
                                destinationURL: fileURL
                            ) { result in
                                switch result {
                                case .success:
                                    expect(FileManager.default.fileExists(atPath: fileURL.absoluteURL.path)).to(equal(true))

                                    guard let fileContents = try? String(contentsOf: fileURL.absoluteURL, encoding: .utf8) else {
                                        fail("Unable to load file contents")
                                        done()
                                        return
                                    }

                                    expect(fileContents).to(equal("Extracted text"))

                                case let .failure(error):
                                    fail("Expected call to getRepresentationContent to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }

                    it("should reject with error when representation has error state") {
                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/2.0/files/12345")
                                && containsQueryParams(["fields": "representations"])
                                && hasHeaderNamed("x-rep-hints", value: "[jpg?dimensions=320x320]")
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetRepresentationsErrorState.json", type(of: self))!,
                                statusCode: 200, headers: ["x-rep-hints": "[jpg?dimensions=320x320]"]
                            )
                        }

                        waitUntil(timeout: 10) { done in

                            self.sut.files.getRepresentationContent(
                                fileId: "12345",
                                representationHint: .thumbnail,
                                destinationURL: fileURL
                            ) { result in
                                switch result {
                                case .success:
                                    fail("Expected call to getRepresentationContent to fail, but instead succeeded")
                                case let .failure(error as BoxAPIError):
                                    guard case .representationCreationFailed = error.message else {
                                        fail("Expected error is not representation creation failed")
                                        done()
                                        return
                                    }

                                    expect(FileManager.default.fileExists(atPath: fileURL.absoluteURL.path)).to(equal(false))
                                default:
                                    fail("Expected error is not representation creation failed")
                                }
                                done()
                            }
                        }
                    }

                    it("should reject with error when representation has unknown state") {
                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/2.0/files/12345")
                                && containsQueryParams(["fields": "representations"])
                                && hasHeaderNamed("x-rep-hints", value: "[jpg?dimensions=320x320]")
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetRepresentationsUnknownState.json", type(of: self))!,
                                statusCode: 200, headers: ["x-rep-hints": "[jpg?dimensions=320x320]"]
                            )
                        }

                        waitUntil(timeout: 10) { done in
                            self.sut.files.getRepresentationContent(
                                fileId: "12345",
                                representationHint: .thumbnail,
                                destinationURL: fileURL
                            ) { result in
                                switch result {
                                case .success:
                                    fail("Expected call to getRepresentationContent to fail, but instead succeeded")
                                case let .failure(error as BoxAPIError):
                                    guard case .representationCreationFailed = error.message else {
                                        fail("Expected error is not representation creation failed")
                                        done()
                                        return
                                    }

                                    expect(FileManager.default.fileExists(atPath: fileURL.absoluteURL.path)).to(equal(false))
                                default:
                                    fail("Expected error is not representation creation failed")
                                }
                                done()
                            }
                        }
                    }

                    it("should check the status when representation has pending state") {
                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/2.0/files/12345")
                                && containsQueryParams(["fields": "representations"])
                                && hasHeaderNamed("x-rep-hints", value: "[extracted_text]")
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("GetRepresentationsPendingState.json", type(of: self))!,
                                statusCode: 200, headers: ["x-rep-hints": "[extracted_text]"]
                            )
                        }

                        stub(
                            condition: isHost("dl.boxcloud.com") && isPath("/api/2.0/internal_files/12345/versions/11111/representations/jpg_thumb_320x320/content")
                        ) { _ in
                            // swiftlint:disable:next force_unwrapping
                            OHHTTPStubsResponse(data: "Extracted text".data(using: .utf8)!, statusCode: 200, headers: [:])
                        }

                        stub(
                            condition: isHost("api.box.com") && isPath("/2.0/internal_files/12345/versions/11111/representations/jpg_thumb_320x320")
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("FileRepresentationState.json", type(of: self))!,
                                statusCode: 200, headers: ["x-rep-hints": "[extracted_text]"]
                            )
                        }

                        waitUntil(timeout: 10) { done in
                            self.sut.files.getRepresentationContent(
                                fileId: "12345",
                                representationHint: .extractedText,
                                destinationURL: fileURL
                            ) { result in
                                switch result {
                                case .success:
                                    expect(FileManager.default.fileExists(atPath: fileURL.absoluteURL.path)).to(equal(true))

                                    guard let fileContents = try? String(contentsOf: fileURL.absoluteURL, encoding: .utf8) else {
                                        fail("Unable to load file contents")
                                        done()
                                        return
                                    }

                                    expect(fileContents).to(equal("Extracted text"))

                                case let .failure(error):
                                    fail("Expected call to getRepresentationContent to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }
            }

            describe("update()") {
                it("should make API call to update info of the file and produce file model when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com") && isPath("/2.0/files/5000948880") && isMethodPUT()
                            && hasJsonBody([
                                "name": "hello.jpg",
                                "parent": [
                                    "id": "0"
                                ],
                                "shared_link": [
                                    "access": "open",
                                    "permissions": ["can_download": true],
                                    "password": "password"
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateFileInfo.json", type(of: self))!,
                            statusCode: 200, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.update(fileId: "5000948880", name: "hello.jpg", description: nil, parentId: "0", sharedLink: .value(SharedLinkData(access: .open, password: .value("password"), canDownload: true)), tags: nil) { result in
                            switch result {
                            case let .success(file):
                                expect(file).toNot(beNil())
                                expect(file).to(beAKindOf(File.self))
                                expect(file.id).to(equal("5000948880"))
                                expect(file.name).to(equal("testfile.jpg"))
                                expect(file.description).to(equal("Test File"))
                                expect(file.size).to(equal(629_644))
                                expect(file.createdBy).to(beAKindOf(User.self))
                                expect(file.createdBy?.name).to(equal("Test User"))
                                expect(file.createdBy?.login).to(equal("testuser@example.com"))
                                expect(file.createdBy?.id).to(equal("17738362"))
                                expect(file.sharedLink).toNot(beNil())
                                expect(file.sharedLink?.access).to(equal(.open))
                                expect(file.sharedLink?.isPasswordEnabled).to(equal(true))
                                expect(file.sharedLink?.permissions?.canDownload).to(equal(true))
                            case let .failure(error):
                                fail("Expected call to update to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should send null value for nested optional parameter when user sets nested optional parameter to null") {
                    stub(
                        condition: isHost("api.box.com") && isPath("/2.0/files/5000948880") && isMethodPUT()
                            && hasJsonBody([
                                "shared_link": [
                                    "password": NSNull()
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateFileInfo.json", type(of: self))!,
                            statusCode: 200, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.update(fileId: "5000948880", sharedLink: .value(SharedLinkData(password: .null))) { result in
                            if case let .failure(error) = result {
                                fail("Expected call to updateFileInfo to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }

                it("should produce error when API call fails") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/50009488812") && isMethodPUT()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateFileInfo.json", type(of: self))!,
                            statusCode: 404, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.update(fileId: "50009488812", name: nil, description: nil, parentId: nil, sharedLink: nil, tags: nil) { result in
                            switch result {
                            case .success:
                                fail("Expected call to fail, but it succeeded")
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
                it("should make API call to copy the file and produce file model when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/files/5000948880/copy")
                            && hasJsonBody([
                                "parent": [
                                    "id": "0"
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CopyFile.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.copy(fileId: "5000948880", parentId: "0") { result in
                            switch result {
                            case let .success(file):
                                expect(file).toNot(beNil())
                                expect(file).to(beAKindOf(File.self))
                                expect(file.id).to(equal("5000948880"))
                                expect(file.name).to(equal("testfile.jpeg"))
                                expect(file.description).to(equal("Test File"))
                                expect(file.size).to(equal(629_644))
                                expect(file.createdBy).to(beAKindOf(User.self))
                                expect(file.createdBy?.name).to(equal("Test User"))
                                expect(file.createdBy?.login).to(equal("testuser@example.com"))
                                expect(file.createdBy?.id).to(equal("17738362"))
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should produce error when the API call fails") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/500094889/copy")) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CopyFile.json", type(of: self))!,
                            statusCode: 404, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.copy(fileId: "500094889", parentId: "0") { result in
                            switch result {
                            case .success:
                                fail("Expected call to fail, but it succeeded")
                            case let .failure(error):
                                expect(error).notTo(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                            }
                            done()
                        }
                    }
                }
            }

            describe("upload()") {
                context("without using preflight check") {
                    it("should produce file model when API call succeeds") {
                        stub(
                            condition:
                            isHost("upload.box.com") &&
                                isPath("/api/2.0/files/content") &&
                                isMethodPOST()
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("UploadFileVersion.json", type(of: self))!,
                                statusCode: 201, headers: [:]
                            )
                        }

                        waitUntil(timeout: 200) { done in
                            let data = "This is upload test file content".data(using: .utf8)!

                            self.sut.files.upload(data: data, name: "tigers.jpeg", parentId: "0", completion: { result in
                                switch result {
                                case let .success(file):
                                    expect(file).toNot(beNil())
                                    expect(file.id).to(equal("5000948880"))
                                    expect(file.name).to(equal("testfile.jpeg"))
                                    expect(file.description).to(equal("Test File"))
                                    expect(file.size).to(equal(629_644))
                                    expect(file.createdBy).to(beAKindOf(User.self))
                                    expect(file.createdBy?.name).to(equal("Test User"))
                                    expect(file.createdBy?.login).to(equal("testuser@example.com"))
                                    expect(file.createdBy?.id).to(equal("17738362"))
                                    expect(file.type).to(equal("file"))
                                case let .failure(error):
                                    fail("Expected call to succeed, but instead got \(error)")
                                }
                                done()
                            })
                        }
                    }
                }

                context("without using preflight check") {
                    it("should produce error when deserializing error response") {
                        stub(
                            condition:
                            isHost("upload.box.com") &&
                                isPath("/api/2.0/files/content") &&
                                isMethodPOST()
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("FullFile.json", type(of: self))!,
                                statusCode: 200, headers: [:]
                            )
                        }

                        waitUntil(timeout: 200) { done in
                            let data = "This is upload test file content".data(using: .utf8)!

                            self.sut.files.upload(data: data, name: "tigers.jpeg", parentId: "0", completion: { result in
                                switch result {
                                case .success:
                                    fail("Expected call to fail, but instead it succeeded.")
                                case let .failure(error):
                                    expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "entries"))))
                                }
                                done()
                            })
                        }
                    }
                }

                context("with preflight check") {
                    it("should produce file model when API call succeeds") {
                        let data = "This is upload test file content".data(using: .utf8)!
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/files/content") &&
                                self.compareJSONBody(["name": "tigers.jpeg", "parent": ["id": "0"], "size": data.count])
                        ) { _ in
                            OHHTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                        }
                        stub(
                            condition: isHost("upload.box.com") && isPath("/api/2.0/files/content") && isMethodPOST()
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("UploadFileVersion.json", type(of: self))!,
                                statusCode: 201, headers: [:]
                            )
                        }

                        waitUntil(timeout: 200) { done in

                            self.sut.files.upload(
                                data: data, name: "tigers.jpeg", parentId: "0", performPreflightCheck: true,
                                completion: { result in
                                    switch result {
                                    case let .success(file):
                                        expect(file).toNot(beNil())
                                        expect(file.id).to(equal("5000948880"))
                                        expect(file.name).to(equal("testfile.jpeg"))
                                        expect(file.description).to(equal("Test File"))
                                        expect(file.size).to(equal(629_644))
                                        expect(file.createdBy).to(beAKindOf(User.self))
                                        expect(file.createdBy?.name).to(equal("Test User"))
                                        expect(file.createdBy?.login).to(equal("testuser@example.com"))
                                        expect(file.createdBy?.id).to(equal("17738362"))
                                        expect(file.type).to(equal("file"))
                                    case let .failure(error):
                                        fail("Expected call to succeed, but instead got \(error)")
                                    }
                                    done()
                                }
                            )
                        }
                    }
                }

                it("should produce an error when preflight check fails and not call upload request") {
                    let data = "This is upload test file content".data(using: .utf8)!
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/files/content") &&
                            self.compareJSONBody(["name": "tigers.jpeg", "parent": ["id": "0"], "size": data.count])
                    ) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 404, headers: [:])
                    }
                    stub(
                        condition: isHost("upload.box.com") && isPath("/api/2.0/files/content") && isMethodPOST()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UploadFileVersion.json", type(of: self))!,
                            statusCode: 201, headers: [:]
                        )
                    }

                    waitUntil(timeout: 200) { done in

                        self.sut.files.upload(
                            data: data, name: "tigers.jpeg", parentId: "0", performPreflightCheck: true,
                            completion: { result in
                                switch result {
                                case .success:
                                    fail("Expected call to fail, but instead it succeeded.")
                                case .failure:
                                    break
                                }
                                done()
                            }
                        )
                    }
                }
            }

            describe("uploadVersion()") {
                context("upload without preflight check") {
                    it("should upload a new version of an existing file in a user’s account") {
                        stub(
                            condition: isHost("upload.box.com") &&
                                isPath("/api/2.0/files/1234/content") &&
                                isMethodPOST()
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("UploadFile.json", type(of: self))!,
                                statusCode: 201, headers: [:]
                            )
                        }
                        waitUntil(timeout: 100) { done in
                            let uploadedData: Data = "This is upload file version test file content".data(using: .utf8)!
                            self.sut.files.uploadVersion(forFile: "1234", name: "FileName", contentModifiedAt: "1994-11-05T13:15:30Z", data: uploadedData) { result in
                                switch result {
                                case let .success(file):
                                    expect(file).toNot(beNil())
                                    expect(file.id).to(equal("5000948880"))
                                    expect(file.name).to(equal("testfile.jpeg"))
                                    expect(file.description).to(equal("Test File"))
                                    expect(file.size).to(equal(629_644))
                                    expect(file.createdBy).to(beAKindOf(User.self))
                                    expect(file.createdBy?.name).to(equal("Test User"))
                                    expect(file.createdBy?.login).to(equal("testuser@example.com"))
                                    expect(file.createdBy?.id).to(equal("17738362"))
                                    expect(file.type).to(equal("file"))
                                case let .failure(error):
                                    fail("Expected call to succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("upload with preflight check") {
                    it("should upload a new version of an existing file in case preflight check passes") {
                        let data = "This is upload test file content".data(using: .utf8)!
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/files/1234/content") &&
                                self.compareJSONBody(["name": "FileName", "size": data.count])
                        ) { _ in
                            OHHTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                        }
                        stub(
                            condition: isHost("upload.box.com") &&
                                isPath("/api/2.0/files/1234/content") &&
                                isMethodPOST()
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("UploadFile.json", type(of: self))!,
                                statusCode: 201, headers: [:]
                            )
                        }
                        waitUntil(timeout: 100) { done in
                            self.sut.files.uploadVersion(forFile: "1234", name: "FileName", contentModifiedAt: "1994-11-05T13:15:30Z", data: data, performPreflightCheck: true) { result in
                                switch result {
                                case let .success(file):
                                    expect(file).toNot(beNil())
                                    expect(file.id).to(equal("5000948880"))
                                    expect(file.name).to(equal("testfile.jpeg"))
                                    expect(file.description).to(equal("Test File"))
                                    expect(file.size).to(equal(629_644))
                                    expect(file.createdBy).to(beAKindOf(User.self))
                                    expect(file.createdBy?.name).to(equal("Test User"))
                                    expect(file.createdBy?.login).to(equal("testuser@example.com"))
                                    expect(file.createdBy?.id).to(equal("17738362"))
                                    expect(file.type).to(equal("file"))
                                case let .failure(error):
                                    fail("Expected call to succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("failed upload with preflight check") {
                    it("should not upload a new version of an existing file in case preflight check fails") {
                        let data = "This is upload test file content".data(using: .utf8)!
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/files/1234/content") &&
                                self.compareJSONBody(["name": "FileName", "size": data.count])
                        ) { _ in
                            OHHTTPStubsResponse(data: Data(), statusCode: 404, headers: [:])
                        }
                        stub(
                            condition: isHost("upload.box.com") &&
                                isPath("/api/2.0/files/1234/content") &&
                                isMethodPOST()
                        ) { _ in
                            OHHTTPStubsResponse(
                                fileAtPath: OHPathForFile("UploadFile.json", type(of: self))!,
                                statusCode: 201, headers: [:]
                            )
                        }
                        waitUntil(timeout: 100) { done in
                            self.sut.files.uploadVersion(forFile: "1234", name: "FileName", contentModifiedAt: "1994-11-05T13:15:30Z", data: data, performPreflightCheck: true) { result in
                                switch result {
                                case .success:
                                    fail("Expected call to fail, but instead call succeeded.")
                                case .failure:
                                    break
                                }
                                done()
                            }
                        }
                    }
                }
            }

            describe("streamUpload()") {

                it("should produce file model when API call succeeds") {
                    stub(condition: isHost("upload.box.com") && isPath("/api/2.0/files/content") && isMethodPOST()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UploadFile.json", type(of: self))!,
                            statusCode: 201, headers: [:]
                        )
                    }

                    let data = Data("hello from tests".utf8)
                    waitUntil(timeout: 999) { done in
                        self.sut.files.streamUpload(stream: InputStream(data: data), fileSize: data.count, name: "tigers.jpeg", parentId: "0", completion: { result in
                            switch result {
                            case let .success(file):
                                expect(file).toNot(beNil())
                                expect(file.id).to(equal("5000948880"))
                                expect(file.name).to(equal("testfile.jpeg"))
                                expect(file.description).to(equal("Test File"))
                                expect(file.size).to(equal(629_644))
                                expect(file.createdBy).to(beAKindOf(User.self))
                                expect(file.createdBy?.name).to(equal("Test User"))
                                expect(file.createdBy?.login).to(equal("testuser@example.com"))
                                expect(file.createdBy?.id).to(equal("17738362"))
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        })
                    }
                }
            }

            describe("preflightCheck()") {
                context("preflight check for new file") {
                    it("should be able to pass the check") {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/files/content") &&
                                self.compareJSONBody(["name": "random.txt", "parent": ["id": "0"], "size": 12345])
                        ) { _ in
                            OHHTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                        }

                        waitUntil(timeout: 10) { done in
                            self.sut.files.preflightCheck(name: "random.txt", parentId: "0", size: 12345) { result in
                                switch result {
                                case .success:
                                    break
                                case let .failure(error):
                                    fail("Expected call to preflightCheck to suceeded, but it failed \(error)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("preflight check for existing file before upload of new version") {
                    it("should be able to pass the check") {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/files/1234/content") &&
                                self.compareJSONBody(["name": "random.txt", "size": 12345])
                        ) { _ in
                            OHHTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                        }

                        waitUntil(timeout: 10) { done in
                            self.sut.files.preflightCheckForNewVersion(forFile: "1234", name: "random.txt", size: 12345) { result in
                                switch result {
                                case .success:
                                    break
                                case let .failure(error):
                                    fail("Expected call to preflightCheck to suceeded, but it failed \(error)")
                                }
                                done()
                            }
                        }
                    }
                }
            }

            describe("lock()") {
                it("should be able to lock a file") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/76017730626") && isMethodPUT() && containsQueryParams(["fields": "lock"]) && hasJsonBody(["lock": ["type": "lock", "is_download_prevented": false]])) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("LockFile.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.lock(
                            fileId: "76017730626",
                            isDownloadPrevented: false,
                            fields: ["lock"]
                        ) { result in
                            switch result {
                            case let .success(file):
                                expect(file).to(beAKindOf(File.self))
                                expect(file.id).to(equal("76017730626"))
                                expect(file.etag).to(equal("2"))
                                expect(file.lock).to(beAKindOf(Lock.self))
                                expect(file.lock?.type).to(equal("lock"))
                                expect(file.lock?.id).to(equal("2126286840"))
                                expect(file.lock?.createdBy).to(beAKindOf(User.self))
                                expect(file.lock?.isDownloadPrevented).to(equal(false))
                            case let .failure(error):
                                fail("Expected call to lock to suceeded, but it failed \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("unlock()") {
                it("should be able to unlock the file") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/76017730626") && isMethodPUT() && containsQueryParams(["fields": "lock"]) && hasJsonBody(["lock": NSNull()])) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UnlockFile.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10) { done in
                        self.sut.files.unlock(
                            fileId: "76017730626",
                            fields: ["lock"]
                        ) { result in
                            switch result {
                            case let .success(file):
                                expect(file).to(beAKindOf(File.self))
                                expect(file.id).to(equal("76017730626"))
                                expect(file.etag).to(equal("2"))
                            // expect(file.lock).to(beNil())
                            case let .failure(error):
                                fail("Expected call to unlock to suceeded, but it failed \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getThumbnail()") {
                it("should be able to get file thumbnail") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/76017730626/thumbnail.jpg") && isMethodGET() && containsQueryParams(["min_height": "256", "max_width": "256"])) { _ in
                        let image = UIImage(named: "image", in: Bundle(for: type(of: self)), compatibleWith: nil)!
                        let data = image.jpegData(compressionQuality: 1.0)!
                        return OHHTTPStubsResponse(data: data, statusCode: 200, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.files.getThumbnail(
                            forFile: "76017730626",
                            extension: .jpg,
                            minHeight: 256,
                            minWidth: nil,
                            maxHeight: nil,
                            maxWidth: 256
                        ) { result in
                            switch result {
                            case let .success(receivedImageData):
                                expect(receivedImageData).toNot(beNil())
                            case let .failure(error):
                                fail("Expected call to getThumbnail to suceeded, but it failed \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getEmbedLink()") {
                beforeEach {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/34122832467") && isMethodGET() && containsQueryParams(["fields": "expiring_embed_link"])) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetEmbedLink.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }

                it("should be able to embed link the file") {
                    waitUntil(timeout: 10) { done in
                        self.sut.files.getEmbedLink(forFile: "34122832467") { result in
                            switch result {
                            case let .success(expiringEmbedLink):
                                expect(expiringEmbedLink).to(beAKindOf(ExpiringEmbedLink.self))
                                expect(expiringEmbedLink.url?.absoluteString).to(equal("https://app.box.com/preview/expiring_embed/gvoct6FE!Qz2rDeyx"))
                            case let .failure(error):
                                fail("Expected call to lockFile to suceeded, but it failed \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listCollaborations()") {
                it("should be able to get file collaboration") {
                    stub(
                        condition: isHost("api.box.com") && isPath("/2.0/files/123456/collaborations") && isMethodGET() && containsQueryParams(["limit": "100"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("FileCollaborations.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10) { done in
                        self.sut.files.listCollaborations(forFile: "123456", limit: 100) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(item):
                                        expect(item).toNot(beNil())
                                        expect(item).to(beAKindOf(Collaboration.self))
                                        expect(item.id).to(equal("14176246"))
                                        expect(item.status?.description).to(equal("accepted"))
                                        expect(item.role?.description).to(equal("editor"))

                                        guard let collaborator = item.accessibleBy?.collaboratorValue, case let .user(user) = collaborator else {
                                            fail("Unable to unwrap expected user value")
                                            done()
                                            return
                                        }
                                        expect(user.id).to(equal("755492"))

                                    case let .failure(error):
                                        fail("Unable to get file collaboration instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get file collaboration instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            describe("listComments()") {
                it("should be able to get file comments") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/5000948880/comments") && isMethodGET() && containsQueryParams(["offset": "0", "limit": "100"])) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("FileComments.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10) { done in

                        self.sut.files.listComments(forFile: "5000948880", offset: 0, limit: 100) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(comment):
                                        expect(comment).toNot(beNil())
                                        expect(comment).to(beAKindOf(Comment.self))
                                        expect(comment.id).to(equal("191969"))
                                        expect(comment.isReplyComment).to(equal(false))
                                        expect(comment.message).to(equal("Test Message"))

                                    case let .failure(error):
                                        fail("Unable to get file comments instead got \(error)")
                                    }
                                    done()
                                }

                            case let .failure(error):
                                fail("Unable to get file comments instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            describe("listTasks()") {
                it("should be able to get file tasks") {

                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/5000948880/tasks") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileTasks.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10) { done in
                        self.sut.files.listTasks(forFile: "5000948880") { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(task):
                                        expect(task).to(beAKindOf(Task.self))
                                        expect(task.id).to(equal("1786931"))

                                    case let .failure(error):
                                        fail("Expected call to list tasks to succeed, but it failed \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Expected call to list tasks to succeed, but it failed \(error)")
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
                            isPath("/2.0/files/5000948880") &&
                            isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/files/5000948880") &&
                            isMethodPUT() &&
                            hasJsonBody(["collections": [["id": "405151"]]])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("AddFileToFavorites.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should make API call to add file to favorites") {
                    waitUntil(timeout: 10) { done in
                        self.sut.files.addToFavorites(fileId: "5000948880", completion: { result in
                            switch result {
                            case let .success(file):
                                expect(file).to(beAKindOf(File.self))
                                expect(file.type).to(equal("file"))
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
                            isPath("/2.0/files/5000948880") &&
                            isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/files/5000948880") &&
                            isMethodPUT() &&
                            hasJsonBody(["collections": []])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("RemoveFileFromFavorites.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should make API call to remove file from favorites") {
                    waitUntil(timeout: 10) { done in
                        self.sut.files.removeFromFavorites(fileId: "5000948880", completion: { result in
                            switch result {
                            case let .success(file):
                                expect(file).to(beAKindOf(File.self))
                                expect(file.type).to(equal("file"))
                            case let .failure(error):
                                fail("Expected call to addFileToFavorites to suceeded, but it failed \(error)")
                            }
                            done()
                        })
                    }
                }
            }
        }

        describe("getVersion()") {

            it("should make API call to get a specified file version") {
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/files/12345/versions/11111")
                        && isMethodGET()
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("FullFileVersion.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.files.getVersion(fileId: "12345", fileVersionId: "11111") { result in
                        switch result {
                        case let .success(fileVersion):
                            expect(fileVersion).toNot(beNil())
                            expect(fileVersion.id).to(equal("11111"))
                            expect(fileVersion.type).to(equal("file_version"))
                            expect(fileVersion.modifiedBy?.type).to(equal("user"))
                            expect(fileVersion.name).to(equal("Screen Shot 2015-08-24 at 11.34.42 AM (1).png"))
                        case let .failure(error):
                            fail("Expected call to getVersion to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("promoteVersion()") {

            it("should make API call to promote a file version to current when call is successful") {
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/files/12345/versions/current")
                        && isMethodPOST()
                        && hasJsonBody([
                            "id": "11111",
                            "type": "file_version"
                        ])
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("FullFileVersion.json", type(of: self))!,
                        statusCode: 201, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.files.promoteVersion(fileId: "12345", fileVersionId: "11111") { result in
                        switch result {
                        case let .success(fileVersion):
                            expect(fileVersion).toNot(beNil())
                            expect(fileVersion.id).to(equal("11111"))
                            expect(fileVersion.type).to(equal("file_version"))
                            expect(fileVersion.modifiedBy?.type).to(equal("user"))
                            expect(fileVersion.name).to(equal("Screen Shot 2015-08-24 at 11.34.42 AM (1).png"))
                        case let .failure(error):
                            fail("Expected call to promoteVersion to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("deleteVersion()") {

            it("should delete the specified file version") {
                stub(condition: isHost("api.box.com") && isPath("/2.0/files/12345/versions/11111") && isMethodDELETE()) { _ in
                    OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                }

                waitUntil(timeout: 10) { done in
                    self.sut.files.deleteVersion(fileId: "12345", fileVersionId: "11111") { response in
                        switch response {
                        case .success:
                            break
                        case let .failure(error):
                            fail("Expected call to deleteVersion to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("listVersions()") {

            it("should be able to get first page of file versions for a specified file") {

                stub(condition: isHost("api.box.com") && isPath("/2.0/files/12345/versions") && isMethodGET()) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("GetFileVersions.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.files.listVersions(fileId: "12345") { results in
                        switch results {
                        case let .success(iterator):
                            iterator.next { result in
                                switch result {
                                case let .success(version):
                                    expect(version).to(beAKindOf(FileVersion.self))
                                    expect(version.id).to(equal("11111"))
                                    expect(version.type).to(equal("file_version"))
                                    expect(version.name).to(equal("Test.pdf"))

                                case let .failure(error):
                                    fail("Expected call to listVersions to succeed, but it failed \(error)")
                                }
                                done()
                            }
                        case let .failure(error):
                            fail("Expected call to listVersions to succeed, but it failed \(error)")
                            done()
                        }
                    }
                }
            }
        }

        describe("getWatermark()") {
            it("should make API call to get a file's watermark") {
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/files/12345/watermark")
                        && isMethodGET()
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("FullWatermark.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.files.getWatermark(fileId: "12345") { result in
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
            it("should make API call to apply a watermark on a file") {
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/files/12345/watermark")
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
                    self.sut.files.applyWatermark(fileId: "12345") { result in
                        switch result {
                        case let .success(watermark):
                            expect(watermark).toNot(beNil())
                            expect(watermark.createdAt?.iso8601).to(equal("2019-08-27T00:55:33Z"))
                            expect(watermark.modifiedAt?.iso8601).to(equal("2019-08-27T01:55:33Z"))
                        case let .failure(error):
                            fail("Expected call to applyWatermark to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("removeWatermark()") {
            it("should remove the watermark from file") {
                stub(condition: isHost("api.box.com") && isPath("/2.0/files/12345/watermark") && isMethodDELETE()) { _ in
                    OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                }

                waitUntil(timeout: 10) { done in
                    self.sut.files.removeWatermark(fileId: "12345") { response in
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

        describe("download()") {
            context("Download file on the provided destination folder") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/files/12345/content") &&
                            isMethodGET() &&
                            containsQueryParams(["version": "1"])
                    ) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                    }
                }
                it("should be able to download a file") {

                    waitUntil(timeout: 10) { done in
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = documentsURL.appendingPathComponent("doc.txt")
                        self.sut.files.download(
                            fileId: "12345",
                            destinationURL: fileURL,
                            version: "1"
                        ) { result in
                            switch result {
                            case .success:
                                expect(FileManager.default.fileExists(atPath: fileURL.absoluteURL.path)).to(equal(true))
                            case let .failure(error):
                                fail("Expected call to download to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }

        describe("delete()") {
            it("should delete file") {
                stub(
                    condition: isHost("api.box.com") &&
                        isPath("/2.0/files/12345") &&
                        isMethodDELETE()
                ) { _ in
                    OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                }

                waitUntil(timeout: 10) { done in
                    self.sut.files.delete(fileId: "12345") { response in
                        switch response {
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

        describe("getSharedLink()") {
            beforeEach {
                stub(
                    condition: isHost("api.box.com") &&
                        isPath("/2.0/files/5000948880") &&
                        isMethodGET() &&
                        containsQueryParams(["fields": "shared_link"])
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("GetFileSharedLink.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }
            }
            it("should download a shared link for a file", closure: {
                waitUntil(timeout: 10) { done in
                    self.sut.files.getSharedLink(forFile: "5000948880") { result in
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
                            isPath("/2.0/files/5000948880") &&
                            isMethodPUT() &&
                            containsQueryParams(["fields": "shared_link"]) &&
                            hasJsonBody(["shared_link": ["access": "open", "password": "frog"]])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileSharedLink.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should update a shared link on a file", closure: {
                    waitUntil(timeout: 10) { done in
                        self.sut.files.setSharedLink(forFile: "5000948880", access: .open, password: .value("frog")) { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).to(equal(.open))
                                expect(sharedLink.previewCount).to(equal(0))
                                expect(sharedLink.downloadCount).to(equal(0))
                                expect(sharedLink.downloadURL).toNot(beNil())
                                expect(sharedLink.isPasswordEnabled).to(equal(true))
                            case let .failure(error):
                                fail("Expected call to setSharedLink to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                })
            }

            context("updating shared link and not updating password") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/files/5000948880") &&
                            isMethodPUT() &&
                            containsQueryParams(["fields": "shared_link"]) &&
                            hasJsonBody(["shared_link": ["access": "open"]])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileSharedLink.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should update a shared link on a file", closure: {
                    waitUntil(timeout: 10) { done in
                        self.sut.files.setSharedLink(forFile: "5000948880", access: SharedLinkAccess.open) { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).to(equal(.open))
                                expect(sharedLink.previewCount).to(equal(0))
                                expect(sharedLink.downloadCount).to(equal(0))
                                expect(sharedLink.downloadURL).toNot(beNil())
                                expect(sharedLink.isPasswordEnabled).to(equal(true))
                            case let .failure(error):
                                fail("Expected call to setSharedLink to suceeded, but instead got \(error)")
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
                            isPath("/2.0/files/5000948880") &&
                            isMethodPUT() &&
                            containsQueryParams(["fields": "shared_link"]) &&
                            hasJsonBody(["shared_link": ["access": "open", "password": NSNull()]])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileSharedLink_PasswordNotEnabled.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should update a shared link on a file", closure: {
                    waitUntil(timeout: 10) { done in
                        self.sut.files.setSharedLink(forFile: "5000948880", access: SharedLinkAccess.open, password: .null) { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).to(equal(.open))
                                expect(sharedLink.previewCount).to(equal(0))
                                expect(sharedLink.downloadCount).to(equal(0))
                                expect(sharedLink.downloadURL).toNot(beNil())
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
                        isPath("/2.0/files/5000948880") &&
                        isMethodPUT() &&
                        hasJsonBody(["shared_link": NSNull()])
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("RemoveFileSharedLink.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }
            }
            it("should delete a shared link for a file", closure: {
                waitUntil(timeout: 10) { done in
                    self.sut.files.deleteSharedLink(forFile: "5000948880") { result in
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

        // MARK: - Chunked Uploads

        describe("createUploadSession()") {
            beforeEach {
                stub(
                    condition: isHost("upload.box.com") &&
                        isPath("/api/2.0/files/upload_sessions") &&
                        isMethodPOST() &&
                        hasJsonBody([
                            "folder_id": "123456",
                            "file_name": "Dummy.txt",
                            "file_size": 2
                        ])

                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("ChunkedUploadSessionNewFile.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }
            }
            it("should create a chunked upload session for a new file") {
                waitUntil(timeout: 10) { done in
                    self.sut.files.createUploadSession(folderId: "123456", fileName: "Dummy.txt", fileSize: 2) { result in
                        switch result {
                        case let .success(session):
                            expect(session.totalParts).to(equal(3))
                            expect(session.partSize).to(equal(8_388_608))
                            expect(session.sessionExpiresAt.iso8601).to(equal("2017-11-09T21:59:16Z"))
                            expect(session.id).to(equal("D5E3F7ADA11A38F0A66AD0B64AACA658"))
                            expect(session.type).to(equal("upload_session"))
                            expect(session.numPartsProcessed).to(equal(0))

                        case let .failure(error):
                            fail("Expected call to createUploadSession to suceeded, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("createUploadSessionForNewVersion()") {
            beforeEach {
                stub(
                    condition: isHost("upload.box.com") &&
                        isPath("/api/2.0/files/12345/upload_sessions") &&
                        isMethodPOST() &&
                        hasJsonBody([
                            "file_name": "Dummy.txt",
                            "file_size": 2
                        ])

                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("ChunkedUploadSessionNewFileVersion.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }
            }
            it("should create a chunked upload session for a new version of file") {
                waitUntil(timeout: 10) { done in
                    self.sut.files.createUploadSessionForNewVersion(ofFile: "12345", fileName: "Dummy.txt", fileSize: 2) { result in
                        switch result {
                        case let .success(session):
                            expect(session.totalParts).to(equal(2))
                            expect(session.partSize).to(equal(8_388_608))
                            expect(session.sessionExpiresAt.iso8601).to(equal("2017-04-18T01:45:15Z"))
                            expect(session.id).to(equal("F971964745A5CD0C001BBE4E58196BFD"))
                            expect(session.type).to(equal("upload_session"))
                            expect(session.numPartsProcessed).to(equal(0))

                        case let .failure(error):
                            fail("Expected call to createUploadSessionForNewFile to suceeded, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("uploadPart()") {

            let data = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.".data(using: .utf8)!

            beforeEach {
                // SHA1 Base64 value was get from https://approsto.com/sha-generator/
                stub(
                    condition: isHost("upload.box.com") &&
                        isPath("/api/2.0/files/upload_sessions/F971964745A5CD0C001BBE4E58196BFD") &&
                        isMethodPUT() &&
                        hasHeaderNamed("digest", value: "sha=zTazcHWKJZs0hFCEpsw4Rzy5Xic=") &&
                        hasHeaderNamed("content-range", value: "bytes 8388608-8389052/100000000")
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("ChunkedUploadSessionUploadPart.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }
            }
            it("should upload part of file using chunked upload session") {

                waitUntil(timeout: 10) { done in
                    self.sut.files.uploadPart(sessionId: "F971964745A5CD0C001BBE4E58196BFD", data: data, offset: 8_388_608, totalSize: 100_000_000) { result in
                        switch result {
                        case let .success(uploadPart):
                            print(uploadPart)
                            expect(uploadPart.part.partId).to(equal("CFEB4BA9"))
                            expect(uploadPart.part.offset).to(equal(0))
                            expect(uploadPart.part.size).to(equal(8_388_608))
                            expect(uploadPart.part.sha1).to(equal("5fde1cce603e6566d20da811c9c8bcccb044d4ae"))

                        case let .failure(error):
                            fail("Expected call to uploadPart to suceeded, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("listUploadSessionParts()") {
            beforeEach {
                stub(
                    condition: isHost("upload.box.com") &&
                        isPath("/api/2.0/files/upload_sessions/F971964745A5CD0C001BBE4E58196BFD/parts") &&
                        isMethodGET()
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("ChunkedUploadSessionListParts.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }
            }

            it("should be able to return the list of parts uploaded so far") {

                waitUntil(timeout: 10) { done in
                    self.sut.files.listUploadSessionParts(sessionId: "F971964745A5CD0C001BBE4E58196BFD") { results in
                        switch results {
                        case let .success(iterator):
                            iterator.next { result in
                                switch result {
                                case let .success(firstPart):
                                    expect(firstPart).to(beAKindOf(UploadPartDescription.self))
                                    expect(firstPart.partId).to(equal("CFEB4BA9"))
                                    expect(firstPart.offset).to(equal(0))
                                    expect(firstPart.size).to(equal(8_388_608))
                                    expect(firstPart.sha1).to(beNil())

                                case let .failure(error):
                                    fail("Expected call to listUploadSessionParts to succeed, but instead got \(error)")
                                }
                                done()
                            }
                        case let .failure(error):
                            fail("Expected call to listUploadSessionParts to suceeded, but instead got \(error)")
                            done()
                        }
                    }
                }
            }
        }

        describe("commmitUpload()") {

            beforeEach {
                stub(
                    condition: isHost("upload.box.com") &&
                        isPath("/api/2.0/files/upload_sessions/F971964745A5CD0C001BBE4E58196BFD/commit") &&
                        isMethodPOST() &&
                        hasJsonBody([
                            "parts": [
                                ["offset": 0, "part_id": "BFDF5379", "size": 8_388_608],
                                ["size": 1_611_392, "part_id": "E8A3ED8E", "offset": 8_388_608]
                            ],
                            "attributes": [
                                "description": "Some file",
                                "content_modified_at": "2017-04-08T00:58:08Z"
                            ]
                        ])

                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("ChunkedUploadSessionCommit.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }
            }
            it("should perform a commit for chunked upload session") {
                waitUntil(timeout: 10) { done in
                    let parts = [
                        UploadPartDescription(partId: "BFDF5379", offset: 0, size: 8_388_608, sha1: nil),
                        UploadPartDescription(partId: "E8A3ED8E", offset: 8_388_608, size: 1_611_392, sha1: nil)
                    ]

                    self.sut.files.commitUpload(
                        sessionId: "F971964745A5CD0C001BBE4E58196BFD",
                        parts: parts,
                        sha1: "kD6a81Nw9ccK6i9QMUYnDDBmqTk=",
                        description: "Some file",
                        contentModifiedAt: Date(fromISO8601String: "2017-04-08T00:58:08Z")
                    ) { result in
                        switch result {
                        case let .success(file):
                            expect(file.type).to(equal("file"))
                            expect(file.id).to(equal("243696906120"))
                            expect(file.sequenceId).to(equal("0"))
                            expect(file.etag).to(equal("0"))
                            expect(file.name).to(equal("chunked-uploads-api-test Thu Nov  2 14:59:24 PDT 2017"))

                        case let .failure(error):
                            fail("Expected call to createUploadSessionForNewFile to suceeded, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("abortUpload()") {
            it("should make API call to abort chunked upload session") {

                stub(
                    condition: isHost("upload.box.com")
                        && isPath("/api/2.0/files/upload_sessions/F971964745A5CD0C001BBE4E58196BFD")
                        && isMethodDELETE()
                ) { _ in
                    OHHTTPStubsResponse(
                        data: Data(), statusCode: 204, headers: [:]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.files.abortUpload(sessionId: "F971964745A5CD0C001BBE4E58196BFD") { result in
                        switch result {
                        case .success:
                            break
                        case let .failure(error):
                            fail("Expected call to abortUpload to suceeded, but instead got \(error)")
                        }

                        done()
                    }
                }
            }
        }

        describe("getUploadSession") {
            it("should make API call to get upload session by ID") {

                stub(
                    condition: isHost("upload.box.com")
                        && isPath("/api/2.0/files/upload_sessions/F971964745A5CD0C001BBE4E58196BFD")
                        && isMethodGET()
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("ChunkedUploadSessionGetSession.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.files.getUploadSession(sessionId: "F971964745A5CD0C001BBE4E58196BFD") { result in
                        switch result {
                        case let .success(session):
                            expect(session.totalParts).to(equal(2))
                            expect(session.partSize).to(equal(8_388_608))
                            expect(session.sessionExpiresAt.iso8601).to(equal("2017-04-18T01:45:15Z"))
                            expect(session.id).to(equal("F971964745A5CD0C001BBE4E58196BFD"))
                            expect(session.type).to(equal("upload_session"))
                            expect(session.numPartsProcessed).to(equal(2))

                        case let .failure(error):
                            fail("Expected call to getUploadSession to suceeded, but instead got \(error)")
                        }

                        done()
                    }
                }
            }
        }
    }
}
