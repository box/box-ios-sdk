//
//  BoxSDKSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 03/12/19.
//  Copyright © 2018 Box Inc. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import Quick

class BoxSDKSpecs: QuickSpec {
    override func spec() {
        describe("BoxSDKSpec") {
            context("User is able to configure SDK with clientId and clientSecret") {
                it("Box SDK should be initialize with clientId and clientSecret") {
                    let sut = BoxSDK(clientId: "1234567", clientSecret: "abcdef")
                    expect(sut.configuration.clientId).to(equal("1234567"))
                    expect(sut.configuration.clientSecret).to(equal("abcdef"))
                }
            }

            context("User is able to get a simple token client") {
                it("instances of SDK class should also allow creating a simple client from a single static token") {
                    let sdk = BoxSDK(clientId: "1234567", clientSecret: "abcdef")
                    let sut = sdk.getClient(token: "a1b2c3d4e5")
                    expect(sut).toNot(beNil())
                    expect(sut).to(beAKindOf(BoxClient.self))
                }
            }

            context("User is able to get a simple token client") {
                it("SDK should also allow creating a simple client from a single static token from static call") {
                    let sut = BoxSDK.getClient(token: "a1b2c3d4e5")
                    expect(sut).toNot(beNil())
                    expect(sut).to(beAKindOf(BoxClient.self))
                }
            }

            context("User is able to update SDK configuration") {
                it("should update the configuration") {
                    let sdk = BoxSDK(clientId: "1234567", clientSecret: "abcdef")

                    expect(sdk.configuration.apiBaseURL).to(equal(BoxSDK.defaultConfiguration.apiBaseURL))
                    expect(sdk.configuration.uploadApiBaseURL).to(equal(BoxSDK.defaultConfiguration.uploadApiBaseURL))

                    expect { try sdk.updateConfiguration(
                        apiBaseURL: URL(string: "https://validurl.com"),
                        uploadApiBaseURL: URL(string: "https://validurl.com")
                    ) }.toNot(throwError())
                    expect(sdk.configuration.apiBaseURL).toNot(equal(BoxSDK.defaultConfiguration.apiBaseURL))
                    expect(sdk.configuration.uploadApiBaseURL).toNot(equal(BoxSDK.defaultConfiguration.uploadApiBaseURL))
                }
            }

            context("User is not able to update SDK configuration with invalid url") {
                it("should not update the configuration but throw error instead") {
                    let sdk = BoxSDK(clientId: "1234567", clientSecret: "abcdef")
                    expect { try sdk.updateConfiguration(
                        apiBaseURL: URL(string: "http://invalidurl"),
                        uploadApiBaseURL: URL(string: "www.invalidurl.com")
                    ) }.to(throwError(BoxSDKError(message: .invalidURL(urlString: "http://invalidurl"))))
                }
            }

            context("User is able to get a OAuth client with a provided token info") {
                it("should initialize client with provided token info when token info is passed in") {
                    let sdk = BoxSDK(clientId: "1234567", clientSecret: "abcdef")
                    let tokenInfo = TokenInfo(accessToken: "a valid token", refreshToken: "a valid refresh token", expiresIn: 3600, tokenType: "bearer")
                    var client: BoxClient?
                    waitUntil(timeout: 10) { done in
                        sdk.getOAuth2Client(tokenInfo: tokenInfo) { result in
                            switch result {
                            case let .success(ouathClient):
                                client = ouathClient
                                client?.session.getAccessToken { result in
                                    switch result {
                                    case let .success(token):
                                        expect(token).to(equal(tokenInfo.accessToken))
                                    case let .failure(error):
                                        fail("getOAuth2Client should succeed, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("getOAuth2Client should succeed, but instead got \(error)")
                            }
                        }
                    }
                }
            }

            context("User is able to get a OAuth client with a provided TokenStore") {
                it("should initialize client with provided TokenStore and valid tokenInfo on it") {
                    let sdk = BoxSDK(clientId: "1234567", clientSecret: "abcdef")
                    var client: BoxClient?
                    let tokenStore = TestTokenStore(shouldFail: false)
                    let tokenInfo = TokenInfo(accessToken: "a valid token", refreshToken: "a valid refresh token", expiresIn: 3600, tokenType: "bearer")
                    tokenStore.write(tokenInfo: tokenInfo) { _ in }
                    waitUntil(timeout: 10) { done in
                        sdk.getOAuth2Client(tokenStore: tokenStore) { result in
                            switch result {
                            case let .success(ouathClient):
                                client = ouathClient
                                client?.session.getAccessToken { result in
                                    switch result {
                                    case let .success(token):
                                        expect(token).to(equal(tokenInfo.accessToken))
                                    case let .failure(error):
                                        fail("getOAuth2Client should succeed, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("getOAuth2Client should succeed, but instead got \(error)")
                            }
                        }
                    }
                }
            }

            context("User is able to get a OAuth client with a provided TokenStore") {
                it("shouldn't initialize client with provided TokenStore because token store fails on token write operation") {
                    let sdk = BoxSDKSpy()
                    var client: BoxClient?
                    let tokenStore = TestTokenStore(shouldFail: false)
                    let tokenInfo = TokenInfo(accessToken: "a valid token", refreshToken: "a valid refresh token", expiresIn: 3600, tokenType: "bearer")
                    tokenStore.write(tokenInfo: tokenInfo) { _ in }
                    tokenStore.shouldFail = true
                    waitUntil(timeout: 10) { done in
                        sdk.getOAuth2Client(tokenStore: tokenStore) { result in
                            switch result {
                            case let .success(ouathClient):
                                client = ouathClient
                                client?.session.getAccessToken { result in
                                    switch result {
                                    case .success:
                                        fail("getOAuth2Client should fail, but instead got success")
                                    case let .failure(error):
                                        expect(error).toNot(beNil())
                                    }
                                }
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                done()
                            }
                        }
                    }
                }
            }

            context("User is able to get a OAuth client with a provided token info") {
                it("should initialize client with provided token info and tokenStore when token info is passed in") {
                    let sdk = BoxSDK(clientId: "1234567", clientSecret: "abcdef")
                    let tokenInfo = TokenInfo(accessToken: "a valid token", refreshToken: "a valid refresh token", expiresIn: 3600, tokenType: "bearer")
                    var client: BoxClient?
                    waitUntil(timeout: 10) { done in
                        sdk.getOAuth2Client(tokenInfo: tokenInfo, tokenStore: TestTokenStore(shouldFail: false)) { result in
                            switch result {
                            case let .success(ouathClient):
                                client = ouathClient
                                client?.session.getAccessToken { result in
                                    switch result {
                                    case let .success(token):
                                        expect(token).to(equal(tokenInfo.accessToken))
                                    case let .failure(error):
                                        fail("getOAuth2Client should succeed, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("getOAuth2Client should succeed, but instead got \(error)")
                            }
                        }
                    }
                }
            }

            context("User is try to get a OAuth client") {
                it("should not initialize client with provided token info and tokenStore as tokenStore fail to write token info ") {
                    let sdk = BoxSDK(clientId: "1234567", clientSecret: "abcdef")
                    let tokenInfo = TokenInfo(accessToken: "a valid token", refreshToken: "a valid refresh token", expiresIn: 3600, tokenType: "bearer")
                    waitUntil(timeout: 10) { done in
                        sdk.getOAuth2Client(tokenInfo: tokenInfo, tokenStore: TestTokenStore(shouldFail: true)) { result in
                            switch result {
                            case let .success(ouathClient):
                                fail("getOAuth2Client should fail, but instead got \(ouathClient)")
                            case let .failure(error):
                                expect(error).toNot(beNil())
                            }
                            done()
                        }
                    }
                }
            }

            context("User is able to get a OAuth client after web flow authorization code exchange") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/oauth2/token")
                            && isMethodPOST()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("AccessToken.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should get a new client after the web flow") {
                    let sdk = BoxSDKSpy()
                    var client: BoxClient?
                    waitUntil(timeout: 1.0) { done in
                        sdk.getOAuth2Client { result in
                            switch result {
                            case let .success(ouathClient):
                                client = ouathClient
                                client?.session.getAccessToken { result in
                                    switch result {
                                    case let .success(token):
                                        expect(token).to(equal("T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl"))
                                    case let .failure(error):
                                        fail("getOAuth2Client should succeed, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("getOAuth2Client should succeed, but instead got \(error)")
                            }
                        }
                    }
                }
            }
        }

        describe("makeAuthorizeURL()") {
            context("specifying all optional parameters") {
                it("should get a new client after the web flow") {
                    let sut = BoxSDK(clientId: "1234567", clientSecret: "abcdef")
                    let state = "123456"
                    let authURL = sut.makeAuthorizeURL(state: state)
                    expect(authURL.absoluteString).to(contain([state, sut.configuration.oauth2AuthorizeURL.absoluteString]))
                    expect(sut.configuration.clientSecret).to(equal("abcdef"))
                }
            }

            context("not specifying any optional parameters") {
                it("should get a new client after the web flow") {
                    let sut = BoxSDK(clientId: "1234567", clientSecret: "abcdef")
                    let authURL = sut.makeAuthorizeURL()
                    expect(authURL.absoluteString).to(contain([sut.configuration.oauth2AuthorizeURL.absoluteString, "1234567"]))
                    expect(authURL.absoluteString).toNot(contain([BoxOAuth2ParamsKey.state]))
                    expect(sut.configuration.clientSecret).to(equal("abcdef"))
                }
            }
        }
    }

    // MARK: - Helpers

    private class BoxSDKSpy: BoxSDK {
        var shouldFailWebAuthorization: Bool

        init(shouldFailWebAuthorization: Bool = false) {
            self.shouldFailWebAuthorization = shouldFailWebAuthorization
            super.init(clientId: "aclientId", clientSecret: "aclientSecret")
        }

        override func obtainAuthorizationCodeFromWebSession(completion: @escaping Callback<String>) {
            if shouldFailWebAuthorization {
                completion(.failure(BoxAPIAuthError(message: .invalidOAuthRedirectConfiguration)))
            }
            else {
                completion(.success("a valid AuthorizationCode"))
            }
        }
    }

    private class TestTokenStore: TokenStore {
        var tokenInfo: TokenInfo?
        var shouldFail: Bool

        init(shouldFail: Bool) {
            self.shouldFail = shouldFail
        }

        func read(completion: @escaping (Result<TokenInfo, Error>) -> Void) {
            shouldFail ? completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure))) : completion(.success(tokenInfo!))
        }

        func write(tokenInfo: TokenInfo, completion: @escaping (Result<Void, Error>) -> Void) {
            if shouldFail {
                completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure)))
            }
            else {
                self.tokenInfo = tokenInfo
                completion(.success(()))
            }
        }

        func clear(completion: @escaping (Result<Void, Error>) -> Void) {
            shouldFail ? completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure))) : completion(.success(()))
        }
    }
}
