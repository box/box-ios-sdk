//
//  SignRequestsModuleIntegrationSpecs.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 17/07/2023.
//  Copyright © 2023 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SignRequestsModuleIntegrationSpecs: QuickSpec {

    override class func spec() {
        var client: BoxClient!
        var rootFolder: Folder!

        beforeSuite {
            initializeClient { createdClient in client = createdClient }
            createFolder(client: client, name: NameGenerator.getUniqueFolderName(for: "SignRequestsModule")) { createdFolder in rootFolder = createdFolder }
        }

        afterSuite {
            deleteFolder(client: client, folder: rootFolder, recursive: true)
        }

        describe("Sign Requests") {
            context("live cycle") {
                var fileToSign1: File?
                var fileToSign2: File?
                var signRequest: SignRequest?

                beforeEach {
                    uploadFile(client: client, fileName: "file_1.txt", dataContent: "content_1".data(using: .utf8)!, toFolder: rootFolder.id) { uploadedFile in fileToSign1 = uploadedFile }
                    uploadFile(client: client, fileName: "file_2.txt", dataContent: "content_2".data(using: .utf8)!, toFolder: rootFolder.id) { uploadedFile in fileToSign2 = uploadedFile }
                }

                afterEach {
                    deleteFile(client: client, file: fileToSign1)
                    deleteFile(client: client, file: fileToSign2)
                }

                it("should correctly create get cancel") {
                    guard let fileToSign1 = fileToSign1, let fileToSign2 = fileToSign2 else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    let signer = SignRequestCreateSigner(
                        email: "sdk_integration_test@boxdemo.com",
                        role: .signer,
                        redirectUrl: "https://www.box.com/redirect_url_signer_1",
                        declinedRedirectUrl: "https://www.box.com/declined_redirect_url_singer_1"
                    )

                    let signParameters = SignRequestCreateParameters(
                        redirectUrl: "https://www.box.com/redirect_url",
                        declinedRedirectUrl: "https://www.box.com/declined_redirect_url"
                    )

                    // Create
                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        client.signRequests.create(
                            signers: [signer],
                            sourceFiles: [
                                SignRequestCreateSourceFile(id: fileToSign1.id),
                                SignRequestCreateSourceFile(id: fileToSign2.id)
                            ],
                            parentFolder: SignRequestCreateParentFolder(id: rootFolder.id),
                            parameters: signParameters
                        ) { result in
                            switch result {
                            case let .success(signRequestResult):
                                signRequest = signRequestResult
                                expect(signRequest?.redirectUrl).to(equal(signParameters.redirectUrl))
                                expect(signRequest?.declinedRedirectUrl).to(equal(signParameters.declinedRedirectUrl))
                                expect(signRequest?.parentFolder.id).to(equal(rootFolder.id))
                                expect(signRequest?.signFiles?.files?.count).to(equal(2))
                            case let .failure(error):
                                fail("Expected create call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let signRequest = signRequest else { return }

                    // Get
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.signRequests.getById(id: signRequest.id) { result in
                            switch result {
                            case let .success(signRequestResult):
                                expect(signRequestResult.redirectUrl).to(equal(signParameters.redirectUrl))
                                expect(signRequestResult.declinedRedirectUrl).to(equal(signParameters.declinedRedirectUrl))
                                expect(signRequestResult.parentFolder.id).to(equal(rootFolder.id))
                                expect(signRequestResult.signFiles?.files?.count).to(equal(2))
                            case let .failure(error):
                                fail("Expected get call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Cancel
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.signRequests.cancelById(id: signRequest.id) { result in
                            switch result {
                            case let .success(signRequestResult):
                                expect(signRequestResult.status).to(equal(.cancelled))
                            case let .failure(error):
                                fail("Expected cancel call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }
        }
    }
}
