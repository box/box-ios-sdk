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
    var sut: BoxClient?

    override func spec() {
        beforeEach {
            self.sut = BoxSDK.getClient(token: "asdasd")
        }

        afterEach {
            self.sut = nil
        }

        describe("BoxClientSpec") {
            context("Box Modules and BoxClient reference relationship") {
                it("BoxClient Module shouldn't have a BoxClient reference once the client is destroyed") {
                    let fileModule = self.sut!.files
                    let foldersModule = self.sut!.folders
                    let usersModule = self.sut!.users
                    self.sut = nil
                    expect(fileModule.boxClient).to(beNil())
                    expect(foldersModule.boxClient).to(beNil())
                    expect(usersModule.boxClient).to(beNil())
                }
            }

            context("Get new client to behave as another user") {
                it("should add as User header to be able to passed it to the Network Client") {
                    let asUserClient = self.sut?.asUser(withId: "1234567")
                    expect(asUserClient?.headers).to(equal([BoxHTTPHeaderKey.asUser: "1234567"]))
                }
            }

            context("BoxClient add valid headers when user request a new client to use with") {
                it("should add proper shared_Link and password header to be able to passed it to the Network Client") {
                    let asUserClient = self.sut?.withSharedLink(url: URL(string: "http://box.com")!, password: "123121")
                    expect(asUserClient?.headers).to(equal([BoxHTTPHeaderKey.boxApi: "shared_link=http://box.com&shared_link_password=123121"]))
                }
            }

            context("BoxClient add valid headers when user request a new client to use with") {
                it("should add shared_Link header to be able to passed it to the Network Client") {
                    let asUserClient = self.sut?.withSharedLink(url: URL(string: "http://box.com")!, password: nil)
                    expect(asUserClient?.headers).to(equal([BoxHTTPHeaderKey.boxApi: "shared_link=http://box.com"]))
                }
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
                    OHHTTPStubsResponse(
                        data: Data(), statusCode: 200, headers: [:]
                    )
                }

                waitUntil(timeout: 10) { done in
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
                    OHHTTPStubsResponse(
                        data: Data(), statusCode: 400, headers: [:]
                    )
                }

                waitUntil(timeout: 10) { done in
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
                    OHHTTPStubsResponse(
                        data: Data(), statusCode: 200, headers: [:]
                    )
                }

                waitUntil(timeout: 10) { done in
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
