//
//  AuthModuleSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/8/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class AuthModuleSpecs: QuickSpec {

    static let clientId: String = "aqswdefrgthyju"
    static let clientSecret: String = "aqswdefrgt"
    static let code: String = "zaqxswedc"

    override class func spec() {
        var sdk: BoxSDK!
        var sut: AuthModule!
        var networkAgent: FakeNetworkAgent!

        beforeEach {
            sdk = BoxSDK(clientId: clientId, clientSecret: clientSecret)
            try? sdk.updateConfiguration(maxRetryAttempts: 0)
            networkAgent = FakeNetworkAgent()
            sut = AuthModule(networkAgent: networkAgent, configuration: sdk.configuration)
        }

        describe("AuthModuleSpecs") {
            context("get access Token after a successful OAuth web authentication") {
                beforeEach {
                    networkAgent.sendHandler = { request in
                        expectRequest(request, method: .post, host: "api.box.com", path: "/oauth2/token", urlEncodedBody: ["client_id": clientId, "client_secret": clientSecret, "code": code, "grant_type": "authorization_code"])
                        return .success(makeResponse(request: request, fixture: "AccessToken.json", statusCode: 200, headers: ["Content-Type": "application/json"]))
                    }
                }

                it("should get access token") {
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.getToken(withCode: "zaqxswedc") { result in
                            switch result {
                            case let .success(tokenInfo):
                                expect(tokenInfo).to(beAKindOf(TokenInfo.self))
                                expect(tokenInfo.accessToken).to(equal("T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl"))
                                expect(tokenInfo.expiresIn).to(equal(3600))
                                expect(tokenInfo.tokenType).to(equal("bearer"))
                                expect(tokenInfo.refreshToken).to(equal("J7rxTiWOHMoSC1isKZKBZWizoRXjkQzig5C6jFgCVJ9bUnsUfGMinKBDLZWP9BgR"))
                            case let .failure(error):
                                fail("OAuth authentication failed got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            context("get access Token after an unsuccessful OAuth web authentication") {
                beforeEach {
                    networkAgent.sendHandler = { request in
                        expectRequest(request, method: .post, host: "api.box.com", path: "/oauth2/token", urlEncodedBody: ["client_id": clientId, "client_secret": clientSecret, "code": code, "grant_type": "authorization_code"])
                        return makeFailure(request: request, jsonObject: ["error": "invalid_grant", "error_description": "Auth code doesn't exist or is invalid for the client"], statusCode: 400)
                    }
                }

                it("should get an 400 error") {
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.getToken(withCode: "zaqxswedc") { result in
                            switch result {
                            case .success:
                                fail("OAuth authentication succeded but was expected to fail")
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                            }
                            done()
                        }
                    }
                }
            }
        }

        describe("revokeToken()") {

            it("should make request to revoke the token") {

                let tokenToRevoke = "asjhkdbfoq83w47gtlqiuwberg"

                networkAgent.sendHandler = { request in
                    expectRequest(request, method: .post, host: "api.box.com", path: "/oauth2/revoke", urlEncodedBody: ["client_id": clientId, "client_secret": clientSecret, "token": tokenToRevoke])
                    return .success(makeResponse(request: request, data: Data(), statusCode: 200))
                }

                waitUntil(timeout: .seconds(10)) { done in
                    sut.revokeToken(token: tokenToRevoke) { result in
                        switch result {
                        case .success:
                            break
                        case let .failure(error):
                            fail("Expected call to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }

            it("should produce error when the revocation request fails") {
                networkAgent.sendHandler = { request in
                    expectRequest(request, method: .post, host: "api.box.com", path: "/oauth2/revoke", urlEncodedBody: ["client_id": clientId, "client_secret": clientSecret, "token": "adjhfgbs"])
                    return makeFailure(request: request, data: Data(), statusCode: 400)
                }

                waitUntil(timeout: .seconds(10)) { done in
                    sut.revokeToken(token: "adjhfgbs") { result in
                        switch result {
                        case .success:
                            fail("Expected call to fail")
                        case let .failure(error):
                            expect(error).to(beAKindOf(BoxSDKError.self))
                        }
                        done()
                    }
                }
            }
        }

        describe("downscopeToken()") {

            it("should make request to downscope the token") {

                let tokenToDownscope = "asjhkdbfoq83w47gtlqiuwberg"

                networkAgent.sendHandler = { request in
                    expectRequest(
                        request,
                        method: .post,
                        host: "api.box.com",
                        path: "/oauth2/token",
                        urlEncodedBody: [
                            "subject_token": tokenToDownscope,
                            "subject_token_type": "urn:ietf:params:oauth:token-type:access_token",
                            "scope": "item_preview item_upload",
                            "grant_type": "urn:ietf:params:oauth:grant-type:token-exchange",
                            "resource": "https://api.box.com/2.0/files/123",
                            "box_shared_link": "https://app.box.com/s/xyz"
                        ],
                        unorderedValueKeys: ["scope"]
                    )
                    return .success(makeResponse(request: request, fixture: "DownscopeToken.json", statusCode: 200, headers: ["Content-Type": "application/json"]))
                }

                waitUntil(timeout: .seconds(10)) { done in
                    sut.downscopeToken(parentToken: tokenToDownscope, scope: [.itemPreview, .itemUpload], resource: "https://api.box.com/2.0/files/123", sharedLink: "https://app.box.com/s/xyz") { result in
                        switch result {
                        case let .success(tokenInfo):
                            expect(tokenInfo).to(beAKindOf(TokenInfo.self))
                            expect(tokenInfo.accessToken).to(equal("qwertyuiop"))
                            expect(tokenInfo.expiresIn).to(equal(3964))
                            expect(tokenInfo.tokenType).to(equal("bearer"))
                            expect(tokenInfo.restrictedToObjects.count).to(equal(2))

                        case let .failure(error):
                            fail("Expected call to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("refresh()") {

            it("should get a valid access token after pass valid refresh token") {

                let refreshToken = "zaqxswedc"

                networkAgent.sendHandler = { request in
                    expectRequest(request, method: .post, host: "api.box.com", path: "/oauth2/token", urlEncodedBody: ["grant_type": "refresh_token", "client_id": clientId, "client_secret": clientSecret, "refresh_token": refreshToken])
                    return .success(makeResponse(request: request, fixture: "AccessToken.json", statusCode: 200, headers: ["Content-Type": "application/json"]))
                }

                waitUntil(timeout: .seconds(10)) { done in
                    sut.refresh(refreshToken: refreshToken) { result in
                        switch result {
                        case let .success(tokenInfo):
                            expect(tokenInfo).to(beAKindOf(TokenInfo.self))
                            expect(tokenInfo.accessToken).to(equal("T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl"))
                            expect(tokenInfo.expiresIn).to(equal(3600))
                            expect(tokenInfo.tokenType).to(equal("bearer"))
                            expect(tokenInfo.refreshToken).to(equal("J7rxTiWOHMoSC1isKZKBZWizoRXjkQzig5C6jFgCVJ9bUnsUfGMinKBDLZWP9BgR"))
                        case let .failure(error):
                            fail("OAuth authentication failed got \(error)")
                        }
                        done()
                    }
                }
            }

            it("should get an 400 error after pass invalid refresh token") {

                networkAgent.sendHandler = { request in
                    expectRequest(request, method: .post, host: "api.box.com", path: "/oauth2/token", urlEncodedBody: ["grant_type": "refresh_token", "client_id": clientId, "client_secret": clientSecret, "refresh_token": "invalid token"])
                    return makeFailure(request: request, jsonObject: ["error": "invalid_grant", "error_description": "Invalid refresh token"], statusCode: 400)
                }

                waitUntil(timeout: .seconds(10)) { done in
                    sut.refresh(refreshToken: "invalid token") { result in
                        switch result {
                        case .success:
                            fail("OAuth authentication succeded but was expected to fail")
                        case let .failure(error):
                            expect(error).toNot(beNil())
                            expect(error).to(beAKindOf(BoxSDKError.self))
                        }
                        done()
                    }
                }
            }
        }
    }
}
