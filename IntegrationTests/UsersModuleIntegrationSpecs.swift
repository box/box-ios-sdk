//
//  UsersModuleIntegrationSpecs.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 11/07/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class UsersModuleIntegrationSpecs: QuickSpec {
    override class func spec() {
        var client: BoxClient!

        beforeSuite {
            initializeClient { createdClient in client = createdClient }
        }

        describe("Users Module") {
            context("avatar") {
                var user: User?

                beforeEach {
                    createUser(client: client, name: NameGenerator.getUniqueName(for: "user")) { createdUser in
                        user = createdUser
                    }
                }

                afterEach {
                    deleteUser(client: client, user: user)
                    user = nil
                }

                it("should correctly add get delete using Data") {
                    guard let user = user else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // Add
                    let name = IntegrationTestResources.smallImage.fileName
                    let data = FileUtil.getFileContent(fileName: name)!

                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        client.users.uploadAvatar(userId: user.id, data: data, name: name) { result in
                            switch result {
                            case let .success(uploadItem):
                                expect(uploadItem.picUrls.preview).toNot(beNil() && beEmpty())
                                expect(uploadItem.picUrls.small).toNot(beNil() && beEmpty())
                                expect(uploadItem.picUrls.large).toNot(beNil() && beEmpty())
                            case let .failure(error):
                                fail("Expected uploadAvatar call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Get
                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        client.users.getAvatar(userId: user.id) { result in
                            switch result {
                            case let .success(data):
                                expect(data).toNot(beNil())
                            case let .failure(error):
                                fail("Expected getAvatar call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Delete
                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        client.users.deleteAvatar(userId: user.id) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected deleteAvatar call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }

                it("should correctly add get delete using InputStream") {
                    guard let user = user else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // Add
                    let name = IntegrationTestResources.smallImage.fileName
                    let path = FileUtil.getFilePath(fileName: name)
                    let inputStream = InputStream(fileAtPath: path)!

                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        client.users.streamUploadAvatar(userId: user.id, stream: inputStream, name: name) { result in
                            switch result {
                            case let .success(uploadItem):
                                expect(uploadItem.picUrls.preview).toNot(beNil() && beEmpty())
                                expect(uploadItem.picUrls.small).toNot(beNil() && beEmpty())
                                expect(uploadItem.picUrls.large).toNot(beNil() && beEmpty())
                            case let .failure(error):
                                fail("Expected streamUploadAvatar call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Get
                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        client.users.getAvatar(userId: user.id) { result in
                            switch result {
                            case let .success(data):
                                expect(data).toNot(beNil())
                            case let .failure(error):
                                fail("Expected getAvatar call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Delete
                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        client.users.deleteAvatar(userId: user.id) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected deleteAvatar call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }
        }
    }
}
