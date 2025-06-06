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

                    let signers = [
                        SignRequestCreateSigner(
                            email: "sdk_integration_test_1@boxdemo.com",
                            role: .signer,
                            redirectUrl: "https://www.box.com/redirect_url_signer_1",
                            declinedRedirectUrl: "https://www.box.com/declined_redirect_url_singer_1",
                            loginRequired: false,
                            password: "password",
                            signerGroupId: "SignerGroup"
                        ),
                        SignRequestCreateSigner(
                            email: "sdk_integration_test_2@boxdemo.com",
                            role: .signer,
                            redirectUrl: "https://www.box.com/redirect_url_signer_2",
                            declinedRedirectUrl: "https://www.box.com/declined_redirect_url_singer_2",
                            loginRequired: false,
                            verificationPhoneNumber: "+48123456789",
                            password: "password",
                            signerGroupId: "SignerGroup"
                        )
                    ]

                    let signParameters = SignRequestCreateParameters(
                        redirectUrl: "https://www.box.com/redirect_url",
                        declinedRedirectUrl: "https://www.box.com/declined_redirect_url",
                        name: "Sign created by iOS SDK.pdf",
                        isPhoneVerificationRequiredToView: false,
                        signatureColor: .black
                    )

                    // Create
                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        client.signRequests.create(
                            signers: signers,
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
                                expect(signRequest?.name).to(equal(signParameters.name))
                                expect(signRequest?.signatureColor).to(equal(signParameters.signatureColor))
                                expect(signRequest?.redirectUrl).to(equal(signParameters.redirectUrl))
                                expect(signRequest?.declinedRedirectUrl).to(equal(signParameters.declinedRedirectUrl))
                                expect(signRequest?.parentFolder.id).to(equal(rootFolder.id))
                                expect(signRequest?.signFiles?.files?.count).to(equal(2))
                                // first signer is the sender with role final_copy_reader, second and third is the recipient with role signer
                                expect(signRequest?.signers.count).to(equal(3))
                                expect(signRequest?.signers[0].role).to(equal(.finalCopyReader))
                                expect(signRequest?.signers[1].signerGroupId).notTo(beNil())
                                expect(signRequest?.signers[1].signerGroupId).to(equal(signRequest?.signers[2].signerGroupId))
                                expect(signRequest?.signers[1].role).to(equal(.signer))
                                expect(signRequest?.signers[1].email).to(equal(signers[0].email))
                                expect(signRequest?.signers[1].redirectUrl).to(equal(signers[0].redirectUrl))
                                expect(signRequest?.signers[1].declinedRedirectUrl).to(equal(signers[0].declinedRedirectUrl))
                                expect(signRequest?.signers[1].loginRequired).to(equal(signers[0].loginRequired))
                                expect(signRequest?.signers[2].signerGroupId).notTo(beNil())
                                expect(signRequest?.signers[2].role).to(equal(.signer))
                                expect(signRequest?.signers[2].email).to(equal(signers[1].email))
                                expect(signRequest?.signers[2].redirectUrl).to(equal(signers[1].redirectUrl))
                                expect(signRequest?.signers[2].declinedRedirectUrl).to(equal(signers[1].declinedRedirectUrl))
                                expect(signRequest?.signers[2].loginRequired).to(equal(signers[1].loginRequired))
                                expect(signRequest?.signers[2].verificationPhoneNumber).to(equal(signers[1].verificationPhoneNumber))
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
