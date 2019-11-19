//
//  KeychainTokenStoreSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/9/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class KeychainTokenStoreSpecs: QuickSpec {
    var sut: KeychainTokenStore = KeychainTokenStore()
    let tokenInfo = TokenInfo(
        accessToken: "1234567890",
        refreshToken: "1234567890",
        expiresIn: 3600,
        tokenType: "bearer"
    )

    override func spec() {
        afterEach {
            self.sut.clear { _ in }
        }

        describe("KeychainTokenStoreSpecs") {

            context("write token info to an empty keychain") {
                it("KeychainStore should insert a new TokenInfo") {
                    waitUntil(timeout: 1.0) { done in
                        self.sut.write(tokenInfo: self.tokenInfo) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("clear should succeed instead got failure \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            context("delete a token info from keychain") {
                it("KeychainStore should delete the tokenInfo from the Keychain") {
                    self.sut.write(tokenInfo: self.tokenInfo) { _ in }
                    waitUntil(timeout: 1.0) { done in
                        self.sut.clear { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("clear should succeed instead got failure \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            context("retreive token info from empty keychain") {
                it("KeychainStore shouldn't return any token info") {
                    waitUntil(timeout: 1.0) { done in
                        self.sut.read { result in
                            switch result {
                            case .success:
                                fail("read should fail instead got success")
                            case .failure:
                                break
                            }
                            done()
                        }
                    }
                }
            }

            context("retreive token info from non empty keychain") {
                it("KeychainStore should return a token info object") {
                    waitUntil(timeout: 1.0) { done in
                        self.sut.write(tokenInfo: self.tokenInfo) { _ in }
                        self.sut.read { result in
                            switch result {
                            case let .success(tokenInfo):
                                expect(tokenInfo).toNot(beNil())
                                expect(tokenInfo).to(beAKindOf(TokenInfo.self))
                                expect(tokenInfo.accessToken).to(equal(self.tokenInfo.accessToken))
                                expect(tokenInfo.refreshToken).to(equal(self.tokenInfo.refreshToken))
                                expect(tokenInfo.expiresIn).to(equal(self.tokenInfo.expiresIn))
//                                expect(tokenInfo.restrictedTo).to(equal(self.tokenInfo.restrictedTo))
                                expect(tokenInfo.tokenType).to(equal(self.tokenInfo.tokenType))
                            case let .failure(error):
                                fail("clear should succeed instead got failure \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
