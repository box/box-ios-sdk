//
//  BoxClientSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 4/1/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class BoxClientSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient?

        beforeEach {
            sut = BoxSDK.getClient(token: "asdasd")
        }

        afterEach {
            sut = nil
        }

        describe("BoxClientSpec") {
            context("Box Modules and BoxClient reference relationship") {
                it("BoxClient Module shouldn't have a BoxClient reference once the client is destroyed") {
                    let fileModule = sut!.files
                    let foldersModule = sut!.folders
                    let usersModule = sut!.users
                    sut = nil
                    expect(fileModule.boxClient).to(beNil())
                    expect(foldersModule.boxClient).to(beNil())
                    expect(usersModule.boxClient).to(beNil())
                }
            }

            context("Get new client to behave as another user") {
                it("should add as User header to be able to passed it to the Network Client") {
                    let asUserClient = sut?.asUser(withId: "1234567")
                    expect(asUserClient?.headers).to(equal([BoxHTTPHeaderKey.asUser: "1234567"]))
                }
            }

            context("BoxClient add valid headers when user request a new client to use with") {
                it("should add proper shared_Link and password header to be able to passed it to the Network Client") {
                    let asUserClient = sut?.withSharedLink(url: URL(string: "http://box.com")!, password: "123121")
                    expect(asUserClient?.headers).to(equal([BoxHTTPHeaderKey.boxApi: "shared_link=http://box.com&shared_link_password=123121"]))
                }
            }

            context("BoxClient add valid headers when user request a new client to use with") {
                it("should add shared_Link header to be able to passed it to the Network Client") {
                    let asUserClient = sut?.withSharedLink(url: URL(string: "http://box.com")!, password: nil)
                    expect(asUserClient?.headers).to(equal([BoxHTTPHeaderKey.boxApi: "shared_link=http://box.com"]))
                }
            }

            describe("destroy()") {
                it("should make request to revoke the current access token") {
                    let currentToken = "sdufhgseit983e4g"
                    let clientID = "ksdjfksadfisdg"
                    let clientSecret = "liuwerfiberdus"
                    let sdk = BoxSDK(clientId: clientID, clientSecret: clientSecret)
                    let client = sdk.getClient(token: currentToken)

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/oauth2/revoke")
                            && isMethodPOST()
                            && self.compareURLEncodedBody(["client_id": clientID, "client_secret": clientSecret, "token": currentToken])
                    ) { _ in
                        HTTPStubsResponse(
                            data: Data(), statusCode: 200, headers: [:]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        client.destroy { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected revocation to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should produce error when revocation request fails") {
                    let client = BoxSDK.getClient(token: "sajkhdbldf")

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
                        client.destroy { result in
                            switch result {
                            case .success:
                                fail("Expected revocation to fail")
                            case let .failure(error):
                                expect(error).to(beAKindOf(BoxSDKError.self))
                            }
                            done()
                        }
                    }
                }

                it("should render client inoperable when revocation request succeeds") {
                    let client = BoxSDK.getClient(token: "sajkhdbldf")

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/oauth2/revoke")
                            && isMethodPOST()
                    ) { _ in
                        HTTPStubsResponse(
                            data: Data(), statusCode: 200, headers: [:]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        client.destroy { _ in
                            client.users.getCurrent { result in
                                guard case let .failure(error) = result else {
                                    fail("Expected request method to result in an error")
                                    done()
                                    return
                                }

                                expect(error).to(matchError(BoxSDKError(message: .clientDestroyed)))
                                done()
                            }
                        }
                    }
                }
            }

            describe("Revoked access token") {
                it("should produce error when access token has been revoked") {
                    let clientID = "ksdjfksadfisdg"
                    let clientSecret = "liuwerfiberdus"
                    let accessToken = "nekoTssecca"
                    let expiresIn: TimeInterval = 3681

                    var client: BoxClient!
                    let sdk = BoxSDK(clientId: clientID, clientSecret: clientSecret)
                    waitUntil(timeout: .seconds(10)) { done in
                        let tokenInfo = TokenInfo(accessToken: accessToken, expiresIn: expiresIn)
                        sdk.getOAuth2Client(tokenInfo: tokenInfo, tokenStore: nil) { result in
                            switch result {
                            case let .success(c):
                                client = c
                            case let .failure(error):
                                fail("Expected getting client to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/users/me")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            data: Data(), statusCode: 401, headers: [:]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        client.users.getCurrent { result in
                            guard case let .failure(error) = result else {
                                fail("Expected request method to result in an error")
                                done()
                                return
                            }

                            expect(error).to(matchError(BoxAPIAuthError(message: .unauthorizedAccess)))
                            done()
                        }
                    }
                }
            }

            context("Custom API calls") {
                it("should make valid get() API call") {
                    stub(condition: isHost("api.box.com")
                        && isPath("/2.0/files/5000948880")
                        && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFileInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut!.get(url: URL.boxAPIEndpoint("/2.0/files/5000948880", configuration: sut!.configuration)) { result in
                            let fileResult: Result<File, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }

                            switch fileResult {
                            case let .success(file):
                                expect(file).toNot(beNil())
                                expect(file.id).to(equal("5000948880"))
                                expect(file.name).to(equal("testfile.jpeg"))
                            case let .failure(error):
                                fail("Expected get call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make valid post() API call") {
                    var body: [String: Any] = [:]
                    body["parent"] = ["id": "33333"]
                    body["url"] = "https://example.com"
                    body["name"] = "Example Web Link"

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/web_links")
                            && isMethodPOST()
                            && hasJsonBody(body)
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullWebLink.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut!.post(
                            url: URL.boxAPIEndpoint("/2.0/web_links", configuration: sut!.configuration),
                            json: body
                        ) { result in
                            let webLinkResult: Result<WebLink, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }

                            switch webLinkResult {
                            case let .success(webLinkItem):
                                expect(webLinkItem).toNot(beNil())
                                expect(webLinkItem.id).to(equal("11111"))
                                expect(webLinkItem.url).to(equal(URL(string: "http://example.com")))
                                expect(webLinkItem.parent?.id).to(equal("33333"))
                                expect(webLinkItem.name).to(equal("Example Web Link"))
                            case let .failure(error):
                                fail("Expected post call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make valid put() API call") {
                    var body: [String: Any] = [:]
                    body["name"] = "testfile.jpg"
                    body["description"] = "Test File"

                    stub(
                        condition: isHost("api.box.com") && isPath("/2.0/files/5000948880")
                            && containsQueryParams(["fields": "name,created_by"])
                            && isMethodPUT()
                            && hasJsonBody(body)
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateFileInfo.json")!,
                            statusCode: 200, headers: [:]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut!.put(
                            url: URL.boxAPIEndpoint("/2.0/files/5000948880", configuration: sut!.configuration),
                            queryParameters: ["fields": "name,created_by"],
                            json: body
                        ) { result in
                            let fileResult: Result<File, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }

                            switch fileResult {
                            case let .success(fileItem):
                                expect(fileItem).toNot(beNil())
                                expect(fileItem).to(beAKindOf(File.self))
                                expect(fileItem.id).to(equal("5000948880"))
                                expect(fileItem.name).to(equal("testfile.jpg"))
                                expect(fileItem.description).to(equal("Test File"))
                                expect(fileItem.size).to(equal(629_644))
                            case let .failure(error):
                                fail("Expected put call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make valid delete() API call") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/files/12345") &&
                            isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut!.delete(url: URL.boxAPIEndpoint("/2.0/files/12345", configuration: sut!.configuration)) { result in
                            if case let .failure(error) = result {
                                fail("Expected delete call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }

                it("should make valid options() API call") {
                    var body: [String: Any] = [:]
                    body["parent"] = ["id": "12345"]
                    body["name"] = "exampleName.txt"

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/files/content")
                            && { $0.httpMethod == "OPTIONS" }
                            && hasJsonBody(body)
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut!.options(
                            url: URL.boxAPIEndpoint("/2.0/files/content", configuration: sut!.configuration),
                            json: body
                        ) { result in
                            if case let .failure(error) = result {
                                fail("Expected options call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }

                it("should make valid download() API call") {
                    let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("doc.txt")

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/files/12345/content") &&
                            isMethodGET() &&
                            containsQueryParams(["version": "1"])
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 200, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut!.download(
                            url: URL.boxAPIEndpoint("/2.0/files/12345/content", configuration: sut!.configuration),
                            downloadDestinationURL: destinationURL,
                            queryParameters: ["version": "1"]
                        ) { result in
                            switch result {
                            case .success:
                                expect(FileManager().fileExists(atPath: destinationURL.path)).to(equal(true))
                            case let .failure(error):
                                fail("Expected download call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }

                it("should make valid send() API call") {
                    let boxRequest = BoxRequest(
                        httpMethod: .get,
                        url: URL.boxAPIEndpoint("/2.0/users/11111", configuration: sut!.configuration),
                        httpHeaders: ["X-Custom-Header": "CustomValue", "Content-Type": "application/vnd.box+json"],
                        queryParams: ["fields": "name,login"],
                        body: .jsonObject(["some_key": "some_value"])
                    )

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/users/11111")
                            && isMethodGET()
                            && hasHeaderNamed("X-Custom-Header", value: "CustomValue")
                            && hasHeaderNamed("Content-Type", value: "application/vnd.box+json")
                            && containsQueryParams(["fields": "name,login"])
                            && hasJsonBody(["some_key": "some_value"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetUserInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut!.send(request: boxRequest) { result in
                            let userResult: Result<User, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }

                            switch userResult {
                            case let .success(user):
                                expect(user.id).to(equal("11111"))
                                expect(user.name).to(equal("Test User"))
                                expect(user.login).to(equal("testuser@example.com"))
                            case let .failure(error):
                                fail("Expected send call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }

    private func makeTokenInfoForDownscope() -> TokenInfo {
        return TokenInfo(
            accessToken: "asjhkdbfoq83w47gtlqiuwberg",
            refreshToken: "valid refresh token",
            expiresIn: 999,
            tokenType: "bearer"
        )
    }
}
