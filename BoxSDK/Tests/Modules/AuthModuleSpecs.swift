//
//  AuthModuleSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/8/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class AuthModuleSpecs: QuickSpec {

    static let clientId: String = "aqswdefrgthyju"
    static let clientSecret: String = "aqswdefrgt"
    static let code: String = "zaqxswedc"

    override class func spec() {
        var sdk: BoxSDK!
        var sut: AuthModule!

        beforeEach {
            sdk = BoxSDK(clientId: clientId, clientSecret: clientSecret)
            let networkAgent = BoxNetworkAgent(configuration: sdk.configuration)
            sut = AuthModule(networkAgent: networkAgent, configuration: sdk.configuration)
        }

        afterEach {
            HTTPStubs.removeAllStubs()
        }

        describe("AuthModuleSpecs") {
            context("get access Token after a successful OAuth web authentication") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/oauth2/token")
                            && isMethodPOST()
                            && compareURLEncodedBody(["client_id": clientId, "client_secret": clientSecret, "code": code, "grant_type": "authorization_code"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "AccessToken.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
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
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/oauth2/token")
                            && isMethodPOST()
                    ) { _ in
                        HTTPStubsResponse(
                            jsonObject: ["error": "invalid_grant", "error_description": "Auth code doesn't exist or is invalid for the client"],
                            statusCode: 400,
                            headers: [:]
                        )
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

                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/revoke")
                        && isMethodPOST()
                        && compareURLEncodedBody(["client_id": clientId, "client_secret": clientSecret, "token": tokenToRevoke])
                ) { _ in
                    HTTPStubsResponse(
                        data: Data(), statusCode: 200, headers: [:]
                    )
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
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/revoke")
                        && isMethodPOST()
                ) { _ in
                    HTTPStubsResponse(
                        data: Data(), statusCode: 400, headers: [:]
                    )
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

                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/token")
                        && isMethodPOST()
                        && compareURLEncodedBody(
                            [
                                "subject_token": tokenToDownscope,
                                "subject_token_type": "urn:ietf:params:oauth:token-type:access_token",
                                "scope": "item_preview item_upload",
                                "grant_type": "urn:ietf:params:oauth:grant-type:token-exchange",
                                "resource": "https://api.box.com/2.0/files/123",
                                "box_shared_link": "https://app.box.com/s/xyz"
                            ],
                            checkClosure: { (checkTuple: CheckClosureTuple) in
                                if let lastPathElement = checkTuple.path.last {
                                    if case let .string(pathKey) = lastPathElement {
                                        if pathKey == "scope" {
                                            if let firstString = checkTuple.first as? String, let secondString = checkTuple.second as? String {
                                                if Set(firstString.split(separator: " ")) == Set(secondString.split(separator: " ")) {
                                                    return .equal
                                                }
                                            }
                                        }
                                    }
                                }

                                return .default
                            }
                        )
                ) { _ in
                    HTTPStubsResponse(
                        fileAtPath: TestAssets.path(forResource: "DownscopeToken.json")!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
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

                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/token")
                        && isMethodPOST()
                        && compareURLEncodedBody(
                            [
                                "grant_type": "refresh_token",
                                "client_id": clientId,
                                "client_secret": clientSecret,
                                "refresh_token": refreshToken
                            ]
                        )
                ) { _ in
                    HTTPStubsResponse(
                        fileAtPath: TestAssets.path(forResource: "AccessToken.json")!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
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

                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/token")
                        && isMethodPOST()
                ) { _ in
                    HTTPStubsResponse(
                        jsonObject: ["error": "invalid_grant", "error_description": "Invalid refresh token"],
                        statusCode: 400,
                        headers: [:]
                    )
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
