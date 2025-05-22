//
//  DelegatedAuthSessionSpecs.swift
//  BoxSDK
//
//  Created by Daniel Cech on 30/11/19.
//  Copyright © 2019 Box. All rights reserved.Box
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class DelegatedAuthSessionSpecs: QuickSpec {

    override class func spec() {
        func logTestMessage(_ message: String) {
            testQueue.async { () in
                testArray.append(message)
                if testArray.count == 4 {
                    testClosure?(testArray)
                }
            }
        }

        var sut: DelegatedAuthSession!

        let testQueue = DispatchQueue(label: "testQueue")
        var testArray = [String]()
        var testClosure: (([String]) -> Void)?

        describe("DelegatedAuthSession") {
            describe("getAccessToken()") {

                it("should return the accessToken as the TokenInfo is in a valid state") {
                    sut = makeSUT(
                        tokenInfo: makeValidTokenInfo(),
                        authClosure: { _, _ in }
                    )

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.getAccessToken { result in
                            switch result {
                            case let .success(token):
                                expect(token).to(equal("valid access token"))
                            case let .failure(error):
                                fail("getAccessToken should succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should get new access token when current token is expired") {
                    sut = makeSUT(
                        tokenInfo: makeExpiredTokenInfo(),
                        authClosure: { _, completion in completion(.success((accessToken: "new access token", expiresIn: 999))) }
                    )

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.getAccessToken { result in
                            switch result {
                            case let .success(token):
                                expect(token).to(equal("new access token"))
                            case let .failure(error):
                                fail("getAccessToken should succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should get new access token (which is expired) when stored token is expired") {
                    sut = makeSUT(
                        tokenInfo: makeExpiredTokenInfo(),
                        authClosure: { _, completion in completion(.success((accessToken: "new access token", expiresIn: 0))) }
                    )

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.getAccessToken { result in
                            switch result {
                            case .success:
                                fail("getAccessToken should not succeed because returned token is expired")
                            case let .failure(error):
                                expect(error).toNot(beNil())
                            }
                            done()
                        }
                    }
                }

                it("should get access token should fail when authClosure returns error") {
                    sut = makeSUT(
                        tokenInfo: makeExpiredTokenInfo(),
                        authClosure: { _, completion in completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure))) }
                    )

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.getAccessToken { result in
                            switch result {
                            case .success:
                                fail("authClosure returned error so getAccessToken should not succeed.")

                            case let .failure(error):
                                expect(error).toNot(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                            }
                            done()
                        }
                    }
                }

                it("should call the refresh token requests serially with mutual exclusion") {
                    var authClosureCalls = 0
                    sut = makeSUT(
                        tokenInfo: makeExpiredTokenInfo(),
                        authClosure: { _, completion in
                            authClosureCalls += 1
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + Double.random(in: 0 ... 5)
                            ) {
                                completion(.success((accessToken: "123456", expiresIn: 9999)))
                            }
                        }
                    )

                    waitUntil(timeout: .seconds(30)) { done in
                        testClosure = { array in
                            DispatchQueue.main.async {
                                expect(array).to(equal(["first result", "second result", "third result", "fourth result"]))
                                expect(authClosureCalls).to(equal(1))
                                done()
                            }
                        }

                        sut.getAccessToken { _ in
                            logTestMessage("first result")
                        }

                        sut.getAccessToken { _ in
                            logTestMessage("second result")
                        }

                        sut.getAccessToken { _ in
                            logTestMessage("third result")
                        }

                        sut.getAccessToken { _ in
                            logTestMessage("fourth result")
                        }
                    }
                }
            }

            describe("downscopeToken()") {

                it("should make request to downscope the token") {
                    sut = makeSUT(
                        tokenInfo: makeTokenInfoForDownscope(),
                        authClosure: { _, _ in }
                    )

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/oauth2/token")
                            && isMethodPOST()
                            && compareURLEncodedBody(
                                [
                                    "subject_token": "asjhkdbfoq83w47gtlqiuwberg",
                                    "subject_token_type": "urn:ietf:params:oauth:token-type:access_token",
                                    "scope": "item_preview item_upload",
                                    "grant_type": "urn:ietf:params:oauth:grant-type:token-exchange",
                                    "resource": "https://api.box.com/2.0/files/123"
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
                        sut.downscopeToken(scope: [.itemPreview, .itemUpload], resource: "https://api.box.com/2.0/files/123") { result in
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
        }

        describe("revokeTokens()") {

            it("should revoke the token when sending valid payload") {
                sut = makeSUT(
                    tokenInfo: makeTokenInfoForRevoke(),
                    authClosure: { _, _ in }
                )
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/revoke")
                        && isMethodPOST()
                        && compareURLEncodedBody(
                            [
                                "client_id": "123",
                                "client_secret": "123",
                                "token": "asjhkdbfoq83w47gtlqiuwberg"
                            ]
                        )
                ) { _ in
                    HTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                }

                waitUntil(timeout: .seconds(10)) { done in
                    sut.revokeTokens { result in
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

            it("shouldn't revoke the token when sending an invalid payload") {
                sut = makeSUT(
                    tokenInfo: makeInvalidTokenInfoForRevoke(),
                    authClosure: { _, _ in }
                )
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/revoke")
                        && isMethodPOST()
                        && compareURLEncodedBody(
                            [
                                "client_id": "123",
                                "client_secret": "123",
                                "token": ""
                            ]
                        )
                ) { _ in
                    HTTPStubsResponse(data: Data(), statusCode: 400, headers: [:])
                }

                waitUntil(timeout: .seconds(10)) { done in
                    sut.revokeTokens { result in
                        switch result {
                        case let .failure(error):
                            expect(error).toNot(beNil())
                            expect(error).to(beAKindOf(BoxSDKError.self))
                        case .success:
                            fail("Expected read to fail, but it succeeded")
                        }
                        done()
                    }
                }
            }
        }
    }

    private static func makeSUT(tokenInfo: TokenInfo, authClosure: @escaping DelegatedAuthClosure) -> DelegatedAuthSession {
        let configuration = try! BoxSDKConfiguration(clientId: "123", clientSecret: "123")
        let networkAgent = BoxNetworkAgent(configuration: configuration)
        let authModule = AuthModule(networkAgent: networkAgent, configuration: configuration)
        let tokenStore = MemoryTokenStore()
        tokenStore.write(tokenInfo: tokenInfo) { _ in }
        return DelegatedAuthSession(
            authModule: authModule,
            configuration: try! BoxSDKConfiguration(),
            tokenInfo: tokenInfo,
            tokenStore: tokenStore,
            authClosure: authClosure,
            uniqueID: "UniqueID"
        )
    }

    private static func makeValidTokenInfo() -> TokenInfo {
        return TokenInfo(
            accessToken: "valid access token",
            refreshToken: "valid refresh token",
            expiresIn: 999,
            tokenType: "bearer"
        )
    }

    private static func makeExpiredTokenInfo() -> TokenInfo {
        return TokenInfo(
            accessToken: "expired access token",
            refreshToken: "a refresh token",
            expiresIn: 0,
            tokenType: "bearer"
        )
    }

    private static func makeTokenInfoForDownscope() -> TokenInfo {
        return TokenInfo(
            accessToken: "asjhkdbfoq83w47gtlqiuwberg",
            refreshToken: "valid refresh token",
            expiresIn: 999,
            tokenType: "bearer"
        )
    }

    private static func makeTokenInfoForRevoke() -> TokenInfo {
        return TokenInfo(
            accessToken: "asjhkdbfoq83w47gtlqiuwberg",
            refreshToken: "valid refresh token",
            expiresIn: 999,
            tokenType: "bearer"
        )
    }

    private static func makeInvalidTokenInfoForRevoke() -> TokenInfo {
        return TokenInfo(
            accessToken: "",
            refreshToken: "valid refresh token",
            expiresIn: 999,
            tokenType: "bearer"
        )
    }
}
