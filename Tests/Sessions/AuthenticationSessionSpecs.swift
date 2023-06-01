//
//  AuthenticationSessionSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 23/09/2021.
//  Copyright © 2021 box. All rights reserved.
//
#if os(iOS)
    @testable import BoxSDK
    import Nimble
    import Quick

    class AuthenticationSessionSpecs: QuickSpec {

        override class func spec() {
            var sdk: BoxSDK!
            let clientId: String = "aqswdefrgthyju"
            let clientSecret: String = "aqswdefrgt"
            let callbackURL: String = "https://app.box.com"

            describe("AuthenticationSession") {

                beforeEach {
                    sdk = BoxSDK(clientId: clientId, clientSecret: clientSecret, callbackURL: callbackURL)
                }

                describe("init()") {
                    it("should create an instacne of AuthenticationSession") {
                        expect {
                            _ = MockAuthenticationSession(
                                url: sdk.makeAuthorizeURL(),
                                callbackURLScheme: URL(string: sdk.configuration.callbackURL)?.scheme
                            ) { _, _ in }
                        }
                        .toNot(throwError())
                    }
                }

                describe("start()") {
                    it("should call start method") {
                        let sut = MockAuthenticationSession(
                            url: sdk.makeAuthorizeURL(),
                            callbackURLScheme: URL(string: sdk.configuration.callbackURL)?.scheme
                        ) { _, _ in }

                        expect(sut.startCalled).to(equal(false))
                        sut.start()
                        expect(sut.startCalled).to(equal(true))
                    }
                }

                describe("cancel()") {
                    it("should call cancel method") {
                        let sut = MockAuthenticationSession(
                            url: sdk.makeAuthorizeURL(),
                            callbackURLScheme: URL(string: sdk.configuration.callbackURL)?.scheme
                        ) { _, _ in }

                        expect(sut.cancelCalled).to(equal(false))
                        sut.cancel()
                        expect(sut.cancelCalled).to(equal(true))
                    }
                }
            }
        }
    }

    private class MockAuthenticationSession: AuthenticationSession {
        var startCalled = false
        var cancelCalled = false

        @discardableResult
        override func start() -> Bool {
            let result = super.start()
            startCalled = true
            return result
        }

        override func cancel() {
            super.cancel()
            cancelCalled = true
        }
    }
#endif
