//
//  CCGAuthSessionSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 09/03/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class CCGAuthSessionSpecs: QuickSpec {

    override class func spec() {
        var sut: CCGAuthSessionMock!

        describe("CCGAuthSession") {

            describe("getAccessToken()") {

                context("for user") {

                    it("should return the accessToken as the TokenInfo is in a valid state") {
                        sut = makeSUT(
                            connectionType: .user("123456"),
                            tokenInfo: makeValidTokenInfo()
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

                    it("should get new access token when current TokenInfo is nil") {
                        sut = makeSUT(
                            connectionType: .user("123456"),
                            tokenInfo: nil
                        )

                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/oauth2/token")
                                && isMethodPOST()
                                && compareURLEncodedBody(
                                    [
                                        "grant_type": "client_credentials",
                                        "client_id": "123",
                                        "client_secret": "456",
                                        "box_subject_id": "123456",
                                        "box_subject_type": "user"
                                    ]
                                )
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "AccessToken.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                        waitUntil(timeout: .seconds(10)) { done in
                            sut.getAccessToken { result in
                                switch result {
                                case let .success(token):
                                    expect(token).to(equal("T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl"))
                                case let .failure(error):
                                    fail("getAccessToken should succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }

                    it("should get new access token when current token is expired") {
                        sut = makeSUT(
                            connectionType: .user("123456"),
                            tokenInfo: makeExpiredTokenInfo()
                        )

                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/oauth2/token")
                                && isMethodPOST()
                                && compareURLEncodedBody(
                                    [
                                        "grant_type": "client_credentials",
                                        "client_id": "123",
                                        "client_secret": "456",
                                        "box_subject_id": "123456",
                                        "box_subject_type": "user"
                                    ]
                                )
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "AccessToken.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                        waitUntil(timeout: .seconds(10)) { done in
                            sut.getAccessToken { result in
                                switch result {
                                case let .success(token):
                                    expect(token).to(equal("T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl"))
                                case let .failure(error):
                                    fail("getAccessToken should succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }

                    it("should call the refresh token requests serially with mutual exclusion") {
                        sut = makeSUT(
                            connectionType: .user("123456"),
                            tokenInfo: makeExpiredTokenInfo()
                        )

                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/oauth2/token")
                                && isMethodPOST()
                                && compareURLEncodedBody(
                                    [
                                        "grant_type": "client_credentials",
                                        "client_id": "123",
                                        "client_secret": "456",
                                        "box_subject_id": "123456",
                                        "box_subject_type": "user"
                                    ]
                                )
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "AccessToken.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                        let queueWrapper = TestQueueWrapper()
                        var getAccessTokenCalls = 0
                        sut.authModuleMock.getCCGTokenClosure = {
                            getAccessTokenCalls += 1
                        }

                        waitUntil(timeout: .seconds(10)) { done in

                            queueWrapper.closure = { array in
                                DispatchQueue.main.async {
                                    expect(array).to(equal(["first result", "second result", "third result", "fourth result"]))
                                    expect(getAccessTokenCalls).to(equal(1))
                                    done()
                                }
                            }

                            sut.getAccessToken { _ in
                                queueWrapper.logMessage("first result")
                            }

                            sut.getAccessToken { _ in
                                queueWrapper.logMessage("second result")
                            }

                            sut.getAccessToken { _ in
                                queueWrapper.logMessage("third result")
                            }

                            sut.getAccessToken { _ in
                                queueWrapper.logMessage("fourth result")
                            }
                        }
                    }

                    it("should produce error when get new access token fails") {
                        sut = makeSUT(
                            connectionType: .user("123456"),
                            tokenInfo: makeExpiredTokenInfo()
                        )

                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/oauth2/token")
                                && isMethodPOST()
                        ) { _ in
                            HTTPStubsResponse(
                                data: Data(), statusCode: 400, headers: [:]
                            )
                        }

                        waitUntil(timeout: .seconds(10)) { done in
                            sut.getAccessToken { result in
                                switch result {
                                case .success:
                                    fail("getAccessToken should fail, but instead got success")
                                case let .failure(error):
                                    expect(error).toNot(beNil())
                                    expect(error).to(beAKindOf(BoxSDKError.self))
                                }
                                done()
                            }
                        }
                    }
                }

                context("for account service") {

                    it("should return the accessToken as the TokenInfo is in a valid state") {
                        sut = makeSUT(
                            connectionType: .applicationService("987654321"),
                            tokenInfo: makeValidTokenInfo()
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

                    it("should get new access token when current TokenInfo is nil") {
                        sut = makeSUT(
                            connectionType: .applicationService("987654321"),
                            tokenInfo: nil
                        )

                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/oauth2/token")
                                && isMethodPOST()
                                && compareURLEncodedBody(
                                    [
                                        "grant_type": "client_credentials",
                                        "client_id": "123",
                                        "client_secret": "456",
                                        "box_subject_id": "987654321",
                                        "box_subject_type": "enterprise"
                                    ]
                                )
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "AccessToken.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                        waitUntil(timeout: .seconds(10)) { done in
                            sut.getAccessToken { result in
                                switch result {
                                case let .success(token):
                                    expect(token).to(equal("T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl"))
                                case let .failure(error):
                                    fail("getAccessToken should succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }

                    it("should get new access token when current token is expired") {
                        sut = makeSUT(
                            connectionType: .applicationService("987654321"),
                            tokenInfo: makeExpiredTokenInfo()
                        )

                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/oauth2/token")
                                && isMethodPOST()
                                && compareURLEncodedBody(
                                    [
                                        "grant_type": "client_credentials",
                                        "client_id": "123",
                                        "client_secret": "456",
                                        "box_subject_id": "987654321",
                                        "box_subject_type": "enterprise"
                                    ]
                                )
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "AccessToken.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                        waitUntil(timeout: .seconds(10)) { done in
                            sut.getAccessToken { result in
                                switch result {
                                case let .success(token):
                                    expect(token).to(equal("T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl"))
                                case let .failure(error):
                                    fail("getAccessToken should succeed, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    }

                    it("should call the refresh token requests serially with mutual exclusion") {
                        sut = makeSUT(
                            connectionType: .applicationService("987654321"),
                            tokenInfo: makeExpiredTokenInfo()
                        )

                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/oauth2/token")
                                && isMethodPOST()
                                && compareURLEncodedBody(
                                    [
                                        "grant_type": "client_credentials",
                                        "client_id": "123",
                                        "client_secret": "456",
                                        "box_subject_id": "987654321",
                                        "box_subject_type": "enterprise"
                                    ]
                                )
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "AccessToken.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                        let queueWrapper = TestQueueWrapper()
                        var getAccessTokenCalls = 0
                        sut.authModuleMock.getCCGTokenClosure = {
                            getAccessTokenCalls += 1
                        }

                        waitUntil(timeout: .seconds(10)) { done in

                            queueWrapper.closure = { array in
                                DispatchQueue.main.async {
                                    expect(array).to(equal(["first result", "second result", "third result", "fourth result"]))
                                    expect(getAccessTokenCalls).to(equal(1))
                                    done()
                                }
                            }

                            sut.getAccessToken { _ in
                                queueWrapper.logMessage("first result")
                            }

                            sut.getAccessToken { _ in
                                queueWrapper.logMessage("second result")
                            }

                            sut.getAccessToken { _ in
                                queueWrapper.logMessage("third result")
                            }

                            sut.getAccessToken { _ in
                                queueWrapper.logMessage("fourth result")
                            }
                        }
                    }

                    it("should produce error when get new access token fails") {
                        sut = makeSUT(
                            connectionType: .applicationService("987654321"),
                            tokenInfo: makeExpiredTokenInfo()
                        )

                        stub(
                            condition: isHost("api.box.com")
                                && isPath("/oauth2/token")
                                && isMethodPOST()
                        ) { _ in
                            HTTPStubsResponse(
                                data: Data(), statusCode: 400, headers: [:]
                            )
                        }

                        waitUntil(timeout: .seconds(10)) { done in
                            sut.getAccessToken { result in
                                switch result {
                                case .success:
                                    fail("getAccessToken should fail, but instead got success")
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

            describe("handleExpiredToken()") {

                it("should clear the token store") {
                    sut = makeSUT(
                        connectionType: .user("123456"),
                        tokenInfo: makeExpiredTokenInfo()
                    )

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.handleExpiredToken { result in
                            if case let .failure(error) = result {
                                fail("Expected call to succeed, but instead got \(error)")
                                done()
                                return
                            }

                            sut.tokenStore.read { result in
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

            describe("revokeTokens()") {

                it("should revoke the token when sending valid payload and token store should be empty") {
                    sut = makeSUT(
                        connectionType: .user("123456"),
                        tokenInfo: makeValidTokenInfoForRevoke()
                    )
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/oauth2/revoke")
                            && isMethodPOST()
                            && compareURLEncodedBody(
                                [
                                    "client_id": "123",
                                    "client_secret": "456",
                                    "token": "revokeToken"
                                ]
                            )
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.revokeTokens { result in
                            switch result {
                            case .success:
                                sut.tokenStore.read { result in
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

                it("shouldn't revoke the token when sending an invalid payload and token store shouldn't be empty") {
                    sut = makeSUT(
                        connectionType: .applicationService("987654321"),
                        tokenInfo: makeExpiredTokenInfo()
                    )

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/oauth2/revoke")
                            && isMethodPOST()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 400, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.revokeTokens { result in
                            switch result {
                            case let .failure(error):
                                expect(error).toNot(beNil())
                                expect(error).to(beAKindOf(BoxSDKError.self))
                                sut.tokenStore.read { result in
                                    switch result {
                                    case let .success(tokenInfo):
                                        expect(error).toNot(beNil())
                                        expect(tokenInfo).to(beAKindOf(TokenInfo.self))
                                    case let .failure(readError):
                                        fail("Expected read to succeed, but instead got \(readError)")
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

            describe("downscopeToken()") {

                it("should make request to downscope the token") {
                    sut = makeSUT(
                        connectionType: .applicationService("987654321"),
                        tokenInfo: makeTokenInfoForDownscope()
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
    }

    private static func makeSUT(
        connectionType: CCGAuthModule.CCGConnectionType,
        tokenInfo: TokenInfo?
    ) -> CCGAuthSessionMock {
        let configuration = try! BoxSDKConfiguration(clientId: "123", clientSecret: "456")
        let networkAgent = BoxNetworkAgent(configuration: configuration)
        let authModule = CCGAuthModuleMock(connectionType: connectionType, networkAgent: networkAgent, configuration: configuration)
        let tokenStore = MemoryTokenStore()

        if let tokenInfo = tokenInfo {
            tokenStore.write(tokenInfo: tokenInfo) { _ in }
        }

        return CCGAuthSessionMock(
            authModule: authModule,
            configuration: try! BoxSDKConfiguration(),
            tokenInfo: tokenInfo,
            tokenStore: tokenStore
        )
    }

    private static func makeValidTokenInfo() -> TokenInfo {
        return TokenInfo(
            accessToken: "valid access token",
            refreshToken: nil,
            expiresIn: 999,
            tokenType: "bearer"
        )
    }

    private static func makeExpiredTokenInfo() -> TokenInfo {
        return TokenInfo(
            accessToken: "expired access token",
            refreshToken: nil,
            expiresIn: 0,
            tokenType: "bearer"
        )
    }

    private static func makeTokenInfoForDownscope() -> TokenInfo {
        return TokenInfo(
            accessToken: "asjhkdbfoq83w47gtlqiuwberg",
            refreshToken: nil,
            expiresIn: 999,
            tokenType: "bearer"
        )
    }

    private static func makeValidTokenInfoForRevoke() -> TokenInfo {
        return TokenInfo(
            accessToken: "revokeToken",
            refreshToken: nil,
            expiresIn: 999,
            tokenType: "bearer"
        )
    }
}

private class CCGAuthSessionMock: CCGAuthSession {
    var authModuleMock: CCGAuthModuleMock {
        return authModule as! CCGAuthModuleMock
    }
}

private class CCGAuthModuleMock: CCGAuthModule {
    var getCCGTokenClosure: (() -> Void)?

    override public func getCCGToken(completion: @escaping TokenInfoClosure) {
        getCCGTokenClosure?()
        super.getCCGToken(completion: completion)
    }
}

private class TestQueueWrapper {
    let queue = DispatchQueue(label: "testQueue")
    var array = [String]()
    var closure: (([String]) -> Void)?
    let triggerCount: Int

    init(triggerCount: Int = 4) {
        self.triggerCount = triggerCount
    }

    func logMessage(_ message: String) {
        queue.async { [weak self] in
            guard let self = self else { return }

            self.array.append(message)
            if self.array.count == 4 {
                self.closure?(self.array)
            }
        }
    }
}
