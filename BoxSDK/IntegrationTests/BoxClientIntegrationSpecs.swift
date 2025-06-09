//
//  BoxClientIntegrationSpecs.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 05/05/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class BoxClientIntegrationSpecs: QuickSpec {

    override class func spec() {
        var client: BoxClient!
        var rootFolder: Folder!

        beforeSuite {
            initializeClient { createdClient in client = createdClient }
            createFolder(client: client, name: NameGenerator.getUniqueFolderName(for: "BoxClient")) { createdFolder in rootFolder = createdFolder }
        }

        afterSuite {
            deleteFolder(client: client, folder: rootFolder, recursive: true)
        }

        describe("BoxClient") {

            context("Custom API calls") {

                context("get()") {
                    var file: File?

                    beforeEach {
                        uploadFile(client: client, fileName: IntegrationTestResources.smallPdf.fileName, toFolder: rootFolder?.id) { uploadedFile in file = uploadedFile }
                    }

                    afterEach {
                        deleteFile(client: client, file: file)
                    }

                    it("should make valid API call") {
                        guard let file = file else {
                            fail("An error occurred during setup initial data")
                            return
                        }

                        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                            client.get(url: URL.boxAPIEndpoint("/2.0/files/\(file.id)", configuration: client.configuration)) { result in
                                let fileResult: Result<File, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }

                                switch fileResult {
                                case let .success(fileItem):
                                    expect(fileItem).toNot(beNil())
                                    expect(fileItem.id).to(equal(file.id))
                                    expect(fileItem.name).to(equal(IntegrationTestResources.smallPdf.fileName))
                                case let .failure(error):
                                    fail("Expected get call to succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("post()") {
                    var webLink: WebLink?

                    afterEach {
                        deleteWebLink(client: client, webLink: webLink)
                    }

                    it("should make valid API call") {
                        var body: [String: Any] = [:]
                        body["parent"] = ["id": rootFolder.id]
                        body["url"] = "https://example.com"
                        body["name"] = "example name"

                        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                            client.post(
                                url: URL.boxAPIEndpoint("/2.0/web_links", configuration: client.configuration),
                                json: body
                            ) { result in
                                let webLinkResult: Result<WebLink, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }

                                switch webLinkResult {
                                case let .success(webLinkItem):
                                    webLink = webLinkItem
                                    expect(webLinkItem).toNot(beNil())
                                    expect(webLinkItem.name).to(equal("example name"))
                                case let .failure(error):
                                    fail("Expected post call to succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("put()") {
                    var file: File?
                    let newFileName = "updatedName.pdf"
                    let newDescription = "Sample description"

                    beforeEach {
                        uploadFile(client: client, fileName: IntegrationTestResources.smallPdf.fileName, toFolder: rootFolder?.id) { uploadedFile in file = uploadedFile }
                    }

                    afterEach {
                        deleteFile(client: client, file: file)
                    }

                    it("should make valid API call") {
                        guard let file = file else {
                            fail("An error occurred during setup initial data")
                            return
                        }

                        var body: [String: Any] = [:]
                        body["name"] = newFileName
                        body["description"] = newDescription

                        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                            client.put(
                                url: URL.boxAPIEndpoint("/2.0/files/\(file.id)", configuration: client.configuration),
                                queryParameters: ["fields": "name,description"],
                                json: body
                            ) { result in
                                let fileResult: Result<File, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }

                                switch fileResult {
                                case let .success(fileItem):
                                    expect(fileItem).toNot(beNil())
                                    expect(fileItem.id).to(equal(file.id))
                                    expect(fileItem.name).to(equal(newFileName))
                                    expect(fileItem.description).to(equal(newDescription))
                                case let .failure(error):
                                    fail("Expected put call to succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("delete()") {
                    var file: File?

                    beforeEach {
                        uploadFile(client: client, fileName: IntegrationTestResources.smallPdf.fileName, toFolder: rootFolder?.id) { uploadedFile in file = uploadedFile }
                    }

                    it("should make valid API call") {
                        guard let file = file else {
                            fail("An error occurred during setup initial data")
                            return
                        }

                        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                            client.delete(url: URL.boxAPIEndpoint("/2.0/files/\(file.id)", configuration: client.configuration)) { result in
                                if case let .failure(error) = result {
                                    fail("Expected delete call to succeed, but instead got \(error)")
                                }

                                done()
                            }
                        }
                    }
                }

                context("options()") {
                    it("should make valid API call") {
                        var body: [String: Any] = [:]
                        body["parent"] = ["id": "\(rootFolder.id)"]
                        body["name"] = "exampleName.txt"

                        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                            client.options(
                                url: URL.boxAPIEndpoint("/2.0/files/content", configuration: client.configuration),
                                json: body
                            ) { result in
                                if case let .failure(error) = result {
                                    fail("Expected options call to succeed, but instead got \(error)")
                                }

                                done()
                            }
                        }
                    }
                }

                context("download()") {
                    var file: File?

                    beforeEach {
                        uploadFile(client: client, fileName: IntegrationTestResources.smallPdf.fileName, toFolder: rootFolder?.id) { uploadedFile in file = uploadedFile }
                    }

                    afterEach {
                        deleteFile(client: client, file: file)
                    }

                    it("should make valid API call") {
                        guard let file = file else {
                            fail("An error occurred during setup initial data")
                            return
                        }

                        let fileContent = FileUtil.getFileContent(fileName: IntegrationTestResources.smallPdf.fileName)!
                        let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(IntegrationTestResources.smallPdf.fileName)

                        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                            client.download(
                                url: URL.boxAPIEndpoint("/2.0/files/\(file.id)/content", configuration: client.configuration),
                                downloadDestinationURL: destinationURL
                            ) { result in
                                switch result {
                                case .success:
                                    expect(FileManager().fileExists(atPath: destinationURL.path)).to(equal(true))

                                    guard let downloadedContent = try? Data(contentsOf: destinationURL) else {
                                        fail("Can not read downloaded file")
                                        return
                                    }

                                    expect(fileContent).to(equal(downloadedContent))
                                case let .failure(error):
                                    fail("Expected download call to succeed, but instead got \(error)")
                                }

                                done()
                            }
                        }
                    }
                }

                context("send()") {
                    var file: File?
                    let newFileName = "updatedName.pdf"
                    let newDescription = "Sample description"

                    beforeEach {
                        uploadFile(client: client, fileName: IntegrationTestResources.smallPdf.fileName, toFolder: rootFolder?.id) { uploadedFile in file = uploadedFile }
                    }

                    afterEach {
                        deleteFile(client: client, file: file)
                    }

                    it("should make valid API call") {
                        guard let file = file else {
                            fail("An error occurred during setup initial data")
                            return
                        }

                        var body: [String: Any] = [:]
                        body["name"] = newFileName
                        body["description"] = newDescription

                        let request = BoxRequest(
                            httpMethod: .put,
                            url: URL.boxAPIEndpoint("/2.0/files/\(file.id)", configuration: client.configuration),
                            queryParams: ["fields": "name,description"],
                            body: .jsonObject(body)
                        )

                        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                            client.send(request: request) { result in
                                let fileResult: Result<File, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }
                                switch fileResult {
                                case let .success(fileItem):
                                    expect(fileItem).toNot(beNil())
                                    expect(fileItem.id).to(equal(file.id))
                                    expect(fileItem.name).to(equal(newFileName))
                                    expect(fileItem.description).to(equal(newDescription))
                                case let .failure(error):
                                    fail("Expected send call to succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
