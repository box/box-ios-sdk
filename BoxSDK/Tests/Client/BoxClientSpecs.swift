//
//  BoxClientSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 4/1/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class BoxClientSpecs: QuickSpec {

    override class func spec() {

        func makeClient(token: String, clientId: String = "ksdjfksadfisdg", clientSecret: String = "liuwerfiberdus", networkAgent: FakeNetworkAgent) -> BoxClient {
            let sdk = BoxSDK(clientId: clientId, clientSecret: clientSecret)
            let authModule = AuthModule(networkAgent: networkAgent, configuration: sdk.configuration)
            let session = SingleTokenSession(token: token, authModule: authModule)
            return BoxClient(networkAgent: networkAgent, session: session, configuration: sdk.configuration)
        }

        func makeOAuth2Client(token: String, clientId: String = "ksdjfksadfisdg", clientSecret: String = "liuwerfiberdus", networkAgent: FakeNetworkAgent) -> BoxClient {
            let sdk = BoxSDK(clientId: clientId, clientSecret: clientSecret)
            let authModule = AuthModule(networkAgent: networkAgent, configuration: sdk.configuration)
            let tokenInfo = TokenInfo(accessToken: token, expiresIn: 3681)
            let session = OAuth2Session(authModule: authModule, tokenInfo: tokenInfo, tokenStore: MemoryTokenStore(), configuration: sdk.configuration)
            return BoxClient(networkAgent: networkAgent, session: session, configuration: sdk.configuration)
        }

        func loadFixture(_ name: String) -> Data {
            let url = URL(fileURLWithPath: TestAssets.path(forResource: name)!)
            // swiftlint:disable:next force_try
            return try! Data(contentsOf: url)
        }

        describe("BoxClientSpec") {
            context("Box Modules and BoxClient reference relationship") {
                it("BoxClient Module shouldn't have a BoxClient reference once the client is destroyed") {
                    var sut: BoxClient? = BoxSDK.getClient(token: "asdasd")
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
                    let sut = BoxSDK.getClient(token: "asdasd")
                    let asUserClient = sut.asUser(withId: "1234567")
                    expect(asUserClient.headers).to(equal([BoxHTTPHeaderKey.asUser: "1234567"]))
                }
            }

            context("BoxClient add valid headers when user request a new client to use with") {
                it("should add proper shared_Link and password header to be able to passed it to the Network Client") {
                    let sut = BoxSDK.getClient(token: "asdasd")
                    let asUserClient = sut.withSharedLink(url: URL(string: "http://box.com")!, password: "123121")
                    expect(asUserClient.headers).to(equal([BoxHTTPHeaderKey.boxApi: "shared_link=http://box.com&shared_link_password=123121"]))
                }
            }

            context("BoxClient add valid headers when user request a new client to use with") {
                it("should add shared_Link header to be able to passed it to the Network Client") {
                    let sut = BoxSDK.getClient(token: "asdasd")
                    let asUserClient = sut.withSharedLink(url: URL(string: "http://box.com")!, password: nil)
                    expect(asUserClient.headers).to(equal([BoxHTTPHeaderKey.boxApi: "shared_link=http://box.com"]))
                }
            }

            describe("destroy()") {
                it("should make request to revoke the current access token") {
                    let currentToken = "sdufhgseit983e4g"
                    let clientID = "ksdjfksadfisdg"
                    let clientSecret = "liuwerfiberdus"
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: currentToken, clientId: clientID, clientSecret: clientSecret, networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        expectRequest(request, method: .post, host: "api.box.com", path: "/oauth2/revoke", urlEncodedBody: ["client_id": clientID, "client_secret": clientSecret, "token": currentToken])
                        return .success(makeResponse(request: request, data: Data(), statusCode: 200))
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
                    let token = "sajkhdbldf"
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: token, networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        expectRequest(request, method: .post, host: "api.box.com", path: "/oauth2/revoke", urlEncodedBody: ["client_id": "ksdjfksadfisdg", "client_secret": "liuwerfiberdus", "token": token])
                        return makeFailure(request: request, data: Data(), statusCode: 400)
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
                    let token = "sajkhdbldf"
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: token, networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        expectRequest(request, method: .post, host: "api.box.com", path: "/oauth2/revoke", urlEncodedBody: ["client_id": "ksdjfksadfisdg", "client_secret": "liuwerfiberdus", "token": token])
                        return .success(makeResponse(request: request, data: Data(), statusCode: 200))
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
                    let networkAgent = FakeNetworkAgent()
                    let client = makeOAuth2Client(token: "nekoTssecca", networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        let response = makeResponse(request: request, data: Data(), statusCode: 401)
                        return .failure(BoxAPIAuthError(message: .unauthorizedAccess, request: request, response: response))
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
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: "asdasd", networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        return .success(makeResponse(request: request, fixture: "GetFileInfo.json", statusCode: 200, headers: ["Content-Type": "application/json"]))
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        client.get(url: URL.boxAPIEndpoint("/2.0/files/5000948880", configuration: client.configuration)) { result in
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
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: "asdasd", networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        return .success(makeResponse(request: request, fixture: "FullWebLink.json", statusCode: 201, headers: ["Content-Type": "application/json"]))
                    }

                    var body: [String: Any] = [:]
                    body["parent"] = ["id": "33333"]
                    body["url"] = "https://example.com"
                    body["name"] = "Example Web Link"

                    waitUntil(timeout: .seconds(10)) { done in
                        client.post(
                            url: URL.boxAPIEndpoint("/2.0/web_links", configuration: client.configuration),
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
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: "asdasd", networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        return .success(makeResponse(request: request, fixture: "UpdateFileInfo.json", statusCode: 200))
                    }

                    var body: [String: Any] = [:]
                    body["name"] = "testfile.jpg"
                    body["description"] = "Test File"

                    waitUntil(timeout: .seconds(10)) { done in
                        client.put(
                            url: URL.boxAPIEndpoint("/2.0/files/5000948880", configuration: client.configuration),
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
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: "asdasd", networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        return .success(makeResponse(request: request, data: Data(), statusCode: 204))
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        client.delete(url: URL.boxAPIEndpoint("/2.0/files/12345", configuration: client.configuration)) { result in
                            if case let .failure(error) = result {
                                fail("Expected delete call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }

                it("should make valid options() API call") {
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: "asdasd", networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        return .success(makeResponse(request: request, data: Data(), statusCode: 200))
                    }

                    var body: [String: Any] = [:]
                    body["parent"] = ["id": "12345"]
                    body["name"] = "exampleName.txt"

                    waitUntil(timeout: .seconds(10)) { done in
                        client.options(
                            url: URL.boxAPIEndpoint("/2.0/files/content", configuration: client.configuration),
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
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: "asdasd", networkAgent: networkAgent)
                    let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("doc.txt")

                    networkAgent.sendHandler = { request in
                        FileManager.default.createFile(atPath: destinationURL.path, contents: Data(), attributes: nil)
                        return .success(makeResponse(request: request, data: Data(), statusCode: 200))
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        client.download(
                            url: URL.boxAPIEndpoint("/2.0/files/12345/content", configuration: client.configuration),
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
                    let networkAgent = FakeNetworkAgent()
                    let client = makeClient(token: "asdasd", networkAgent: networkAgent)

                    networkAgent.sendHandler = { request in
                        return .success(makeResponse(request: request, fixture: "GetUserInfo.json", statusCode: 200, headers: ["Content-Type": "application/json"]))
                    }

                    let boxRequest = BoxRequest(
                        httpMethod: .get,
                        url: URL.boxAPIEndpoint("/2.0/users/11111", configuration: client.configuration),
                        httpHeaders: ["X-Custom-Header": "CustomValue", "Content-Type": "application/vnd.box+json"],
                        queryParams: ["fields": "name,login"],
                        body: .jsonObject(["some_key": "some_value"])
                    )

                    waitUntil(timeout: .seconds(10)) { done in
                        client.send(request: boxRequest) { result in
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
}
