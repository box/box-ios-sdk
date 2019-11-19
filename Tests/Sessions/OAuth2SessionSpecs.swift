//
//  OAuth2SessionUnitSpec.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/11/19.
//  Copyright © 2019 Box. All rights reserved.Box
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class OAuth2SessionSpecs: QuickSpec {

    private var sut: OAuth2SessionMock!

    private let testQueue = DispatchQueue(label: "testQueue")
    private var testArray = [String]()
    private var testClosure: (([String]) -> Void)?

    private func logTestMessage(_ message: String) {
        testQueue.async { [weak self] in
            guard let self = self else { return }

            self.testArray.append(message)
            if self.testArray.count == 4 {
                self.testClosure?(self.testArray)
            }
        }
    }

    override func spec() {
        describe("OAuth2Session") {

            describe("getAccessToken()") {

                it("should return the access token when the session has a valid token") {
                    self.sut = self.makeSUT(tokenInfo: self.makeValidTokenInfo())
                    waitUntil(timeout: 10) { done in
                        self.sut.getAccessToken { result in
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

                it("should call to refresh token when the token is expired") {
                    self.sut = self.makeSUT(tokenInfo: self.makeExpiredTokenInfo())
                    waitUntil(timeout: 10) { done in
                        self.sut.getAccessToken { result in
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

                it("should call the refresh token requests serially with mutual exclusion") {
                    self.sut = self.makeSUT(tokenInfo: self.makeExpiredTokenInfo())
                    var refreshTokenCalls = 0
                    self.sut.refreshTokenClosure = {
                        refreshTokenCalls += 1
                    }

                    waitUntil(timeout: 10) { done in

                        self.testClosure = { array in
                            DispatchQueue.main.async {
                                expect(array).to(equal(["first result", "second result", "third result", "fourth result"]))
                                expect(refreshTokenCalls).to(equal(1))
                                done()
                            }
                        }

                        self.sut.getAccessToken { _ in
                            self.logTestMessage("first result")
                        }

                        self.sut.getAccessToken { _ in
                            self.logTestMessage("second result")
                        }

                        self.sut.getAccessToken { _ in
                            self.logTestMessage("third result")
                        }

                        self.sut.getAccessToken { _ in
                            self.logTestMessage("fourth result")
                        }
                    }
                }
            }

            describe("refreshToken()") {

                it("should attempt to refresh access token") {
                    self.sut = self.makeSUT(tokenInfo: self.makeExpiredTokenInfo())
                    waitUntil(timeout: 10) { done in
                        self.sut.refreshToken { result in
                            switch result {
                            case let .success(token):
                                expect(token).to(equal("new access token"))
                            case let .failure(error):
                                fail("refreshToken should succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should produce error when session has invalid token info") {
                    self.sut = self.makeSUT(tokenInfo: self.makeInvalidTokenInfo())
                    waitUntil(timeout: 10) { done in
                        self.sut.refreshToken { result in
                            switch result {
                            case .success:
                                fail("refreshToken should fail, but instead got success")
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                            }
                            done()
                        }
                    }
                }

                it("should produce error when refresh fails") {
                    self.sut = self.makeSUT(tokenInfo: self.makeExpiredTokenInfo(), needToFailRefreshToken: true)
                    waitUntil(timeout: 10) { done in
                        self.sut.refreshToken { result in
                            switch result {
                            case .success:
                                fail("refreshToken should fail, but instead got success")
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                            }
                            done()
                        }
                    }
                }
            }

            describe("handleExpiredToken()") {

                it("should clear the token store") {
                    self.sut = self.makeSUT(tokenInfo: self.makeExpiredTokenInfo(), needToFailRefreshToken: true)
                    waitUntil(timeout: 10) { done in
                        self.sut.handleExpiredToken { result in
                            if case let .failure(error) = result {
                                fail("Expected call to succeed, but instead got \(error)")
                                done()
                                return
                            }

                            self.sut.tokenStore.read { result in
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

            describe("downscopeToken()") {

                it("should make request to downscope the token") {
                    self.sut = self.makeSUT(tokenInfo: self.makeTokenInfoForDownscope(), needToFailRefreshToken: true)

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/oauth2/token")
                            && isMethodPOST()
                            && self.compareURLEncodedBody(
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
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("DownscopeToken.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.downscopeToken(scope: [.itemPreview, .itemUpload], resource: "https://api.box.com/2.0/files/123") { result in
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
                self.sut = self.makeSUT(tokenInfo: self.makeValidTokenInfoForRevoke(), needToFailRefreshToken: true)
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/revoke")
                        && isMethodPOST()
                        && self.compareURLEncodedBody(
                            [
                                "client_id": "123",
                                "client_secret": "123",
                                "token": "revokeToken"
                            ]
                        )
                ) { _ in
                    OHHTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                }

                waitUntil(timeout: 10) { done in
                    self.sut.revokeTokens { result in
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

            it("should revoke the token when sending valid payload and token store should be empty") {
                self.sut = self.makeSUT(tokenInfo: self.makeValidTokenInfoForRevoke(), needToFailRefreshToken: true)
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/revoke")
                        && isMethodPOST()
                        && self.compareURLEncodedBody(
                            [
                                "client_id": "123",
                                "client_secret": "123",
                                "token": "revokeToken"
                            ]
                        )
                ) { _ in
                    OHHTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                }

                waitUntil(timeout: 10) { done in
                    self.sut.revokeTokens { result in
                        switch result {
                        case .success:
                            self.sut.tokenStore.read { result in
                                switch result {
                                case .success:
                                    fail("Expected read to fail, but it succeeded")
                                case .failure:
                                    break
                                }
                            }
                        case let .failure(error):
                            fail("Expected call to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }

            it("shouldn't revoke the token when sending an invalid payload") {
                self.sut = self.makeSUT(tokenInfo: self.makeInvalidTokenInfo(), needToFailRefreshToken: true)
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/revoke")
                        && isMethodPOST()
                        && self.compareURLEncodedBody(
                            [
                                "client_id": "123",
                                "client_secret": "123",
                                "token": "revoke Token"
                            ]
                        )
                ) { _ in
                    OHHTTPStubsResponse(data: Data(), statusCode: 400, headers: [:])
                }

                waitUntil(timeout: 10) { done in
                    self.sut.revokeTokens { result in
                        switch result {
                        case let .failure(error):
                            expect(error).toNot(beNil())
                            expect(error).to(beAKindOf(BoxSDKError.self))
                        case .success:
                            fail("Expected call to fail, but it succeeded")
                        }
                        done()
                    }
                }
            }

            it("shouldn't revoke the token when sending an invalid payload and token store shouldn't be empty") {
                self.sut = self.makeSUT(tokenInfo: self.makeInvalidTokenInfo(), needToFailRefreshToken: true)
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/oauth2/revoke")
                        && isMethodPOST()
                        && self.compareURLEncodedBody(
                            [
                                "client_id": "123",
                                "client_secret": "123",
                                "token": "revoke Token"
                            ]
                        )
                ) { _ in
                    OHHTTPStubsResponse(data: Data(), statusCode: 400, headers: [:])
                }

                waitUntil(timeout: 10) { done in
                    self.sut.revokeTokens { result in
                        switch result {
                        case let .failure(error):
                            expect(error).toNot(beNil())
                            expect(error).to(beAKindOf(BoxSDKError.self))
                            self.sut.tokenStore.read { result in
                                switch result {
                                case let .success(tokenInfo):
                                    expect(error).toNot(beNil())
                                    expect(tokenInfo).to(beAKindOf(TokenInfo.self))
                                case .failure:
                                    fail("Expected read to fail, but it succeeded")
                                }
                            }
                        case .success:
                            fail("Expected read to fail, but it succeeded")
                        }
                        done()
                    }
                }
            }
        }
    }

    private func makeSUT(tokenInfo: TokenInfo, needToFailRefreshToken: Bool = false) -> OAuth2SessionMock {
        let configuration = try! BoxSDKConfiguration(clientId: "123", clientSecret: "123")
        let networkAgent = BoxNetworkAgent(configuration: configuration)
        let authModule = AuthModuleSpy(networkAgent: networkAgent, configuration: configuration, needsToFailRefresh: needToFailRefreshToken)
        let tokenStore = MemoryTokenStore()
        tokenStore.write(tokenInfo: tokenInfo) { _ in }
        return OAuth2SessionMock(
            authModule: authModule,
            tokenInfo: tokenInfo,
            tokenStore: tokenStore,
            configuration: try! BoxSDKConfiguration()
        )
    }

    private class AuthModuleSpy: AuthModule {
        var needsToFailRefresh: Bool

        init(networkAgent: BoxNetworkAgent, configuration: BoxSDKConfiguration, needsToFailRefresh: Bool) {
            self.needsToFailRefresh = needsToFailRefresh
            super.init(networkAgent: networkAgent, configuration: configuration)
        }

        override func refresh(refreshToken _: String, completion: @escaping TokenInfoClosure) {
            if needsToFailRefresh {
                completion(.failure(BoxAPIAuthError(message: .unauthorizedAccess)))
            }
            else {
                completion(.success(TokenInfo(
                    accessToken: "new access token",
                    refreshToken: "new refresh token",
                    expiresIn: 999,
                    tokenType: "bearer"
                )))
            }
        }
    }

    private func makeValidTokenInfo() -> TokenInfo {
        return TokenInfo(
            accessToken: "valid access token",
            refreshToken: "valid refresh token",
            expiresIn: 999,
            tokenType: "bearer"
        )
    }

    private func makeExpiredTokenInfo() -> TokenInfo {
        return TokenInfo(
            accessToken: "expired access token",
            refreshToken: "a refresh token",
            expiresIn: 0,
            tokenType: "bearer"
        )
    }

    private func makeInvalidTokenInfo() -> TokenInfo {
        return TokenInfo(
            accessToken: "valid access token",
            refreshToken: nil,
            expiresIn: 0,
            tokenType: "bearer"
        )
    }

    private func makeTokenInfoForDownscope() -> TokenInfo {
        return TokenInfo(
            accessToken: "asjhkdbfoq83w47gtlqiuwberg",
            refreshToken: "valid refresh token",
            expiresIn: 999,
            tokenType: "bearer"
        )
    }

    private func makeValidTokenInfoForRevoke() -> TokenInfo {
        return TokenInfo(
            accessToken: "revokeToken",
            refreshToken: "valid refresh token",
            expiresIn: 999,
            tokenType: "bearer"
        )
    }
}

private class OAuth2SessionMock: OAuth2Session {
    var handleExpiredTokenCalled = false
    var refreshTokenCalled = false
    var getTokenCalled = false

    var handleExpiredTokenClosure: (() -> Void)?
    var refreshTokenClosure: (() -> Void)?
    var getAccessTokenClosure: (() -> Void)?

    override func handleExpiredToken(completion: @escaping Callback<Void>) {
        super.handleExpiredToken(completion: completion)
        handleExpiredTokenCalled = true
        handleExpiredTokenClosure?()
    }

    override func refreshToken(completion: @escaping AccessTokenClosure) {
        super.refreshToken(completion: completion)
        refreshTokenCalled = true
        refreshTokenClosure?()
    }

    override func getAccessToken(completion: @escaping AccessTokenClosure) {
        super.getAccessToken(completion: completion)
        getTokenCalled = true
        getAccessTokenClosure?()
    }
}
