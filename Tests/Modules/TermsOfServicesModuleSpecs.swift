//
//  TermsOfServicesModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/20/19.
//  Copyright © 2019 box. All rights reserved.
//
@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

import Foundation

class TermsOfServicesModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        beforeEach {
            self.sut = BoxSDK.getClient(token: "")
        }

        afterEach {
            OHHTTPStubs.removeAllStubs()
        }

        describe("TermsOfServicesModule") {

            describe("create()") {
                it("should make API call to create a Terms of Service when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/terms_of_services")
                            && isMethodPOST()
                            && hasJsonBody([
                                "status": "enabled",
                                "tos_type": "managed",
                                "text": "Example Text"
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateTermsOfService.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.termsOfService.create(status: TermsOfServiceStatus.enabled, tosType: TermsOfServiceType.managed, text: "Example Text") { result in
                            switch result {
                            case let .success(termsOfService):
                                expect(termsOfService).toNot(beNil())
                                expect(termsOfService).to(beAKindOf(TermsOfService.self))
                                expect(termsOfService.id).to(equal("12345"))
                                expect(termsOfService.text).to(equal("Example Text"))
                                expect(termsOfService.status).to(equal(.enabled))
                                expect(termsOfService.tosType).to(equal(.managed))
                            case let .failure(error):
                                fail("Expected call to create to succeed but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("update()") {
                it("should make API call to update a Terms of Service when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/terms_of_services/12345")
                            && isMethodPUT()
                            && hasJsonBody([
                                "text": "Example Text",
                                "status": "enabled"
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("FullTermsOfService.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.termsOfService.update(tosId: "12345", text: "Example Text", status: TermsOfServiceStatus.enabled) { result in
                            switch result {
                            case let .success(termsOfService):
                                expect(termsOfService).toNot(beNil())
                                expect(termsOfService).to(beAKindOf(TermsOfService.self))
                                expect(termsOfService.id).to(equal("12345"))
                                expect(termsOfService.text).to(equal("Example Text"))
                                expect(termsOfService.status).to(equal(.enabled))
                                expect(termsOfService.tosType).to(equal(.managed))
                            case let .failure(error):
                                fail("Expected call to update to succeed but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("get()") {
                it("should make API call to get a Terms of Service when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/terms_of_services/12345")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("FullTermsOfService.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.termsOfService.get(tosId: "12345") { result in
                            switch result {
                            case let .success(termsOfService):
                                expect(termsOfService).toNot(beNil())
                                expect(termsOfService).to(beAKindOf(TermsOfService.self))
                                expect(termsOfService.id).to(equal("12345"))
                                expect(termsOfService.text).to(equal("Example Text"))
                                expect(termsOfService.status).to(equal(.enabled))
                                expect(termsOfService.tosType).to(equal(.managed))
                            case let .failure(error):
                                fail("Expected call to get to succeed but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listForEnterprise()") {
                it("should make API call to get all Terms of Services when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/terms_of_services")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetTermsOfServices.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.termsOfService.listForEnterprise() { result in
                            switch result {
                            case let .success(tos):
                                expect(tos).notTo(beEmpty())
                                expect(tos[0]).to(beAKindOf(TermsOfService.self))
                                expect(tos[0].id).to(equal("12345"))
                                expect(tos[0].status).to(equal(.enabled))
                                expect(tos[0].tosType).to(equal(.managed))
                                expect(tos[1].id).to(equal("88888"))
                                expect(tos[1].status).to(equal(.disabled))
                                expect(tos[1].tosType).to(equal(.external))
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            it("should make API call to get the managed Terms of Service when call is successful") {
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/terms_of_services")
                        && isMethodGET()
                        && containsQueryParams(["tos_type": "managed"])
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("GetManagedTermsOfService.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.termsOfService.listForEnterprise(tosType: TermsOfServiceType.managed) { result in
                        switch result {
                        case let .success(tos):
                            expect(tos).notTo(beEmpty())
                            expect(tos[0]).to(beAKindOf(TermsOfService.self))
                            expect(tos[0].id).to(equal("12345"))
                            expect(tos[0].status).to(equal(.enabled))
                            expect(tos[0].tosType).to(equal(.managed))
                        case let .failure(error):
                            fail("Expected call to succeed, but it got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("createUserStatus()") {
            it("should make API call to create a Terms of Service User Status when call is successful") {
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/terms_of_service_user_statuses")
                        && isMethodPOST()
                        && hasJsonBody([
                            "tos": [
                                "type": "terms_of_service",
                                "id": "12345"
                            ],
                            "user": [
                                "type": "user",
                                "id": "11111"
                            ],
                            "is_accepted": true
                        ])
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("FullTermsOfServiceUserStatus.json", type(of: self))!,
                        statusCode: 201, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.termsOfService.createUserStatus(tosId: "12345", isAccepted: true, userId: "11111") { result in
                        switch result {
                        case let .success(userStatus):
                            expect(userStatus).toNot(beNil())
                            expect(userStatus).to(beAKindOf(TermsOfServiceUserStatus.self))
                            expect(userStatus.id).to(equal("88888"))
                            expect(userStatus.isAccepted).to(equal(true))
                            expect(userStatus.user?.id).to(equal("11111"))
                            expect(userStatus.tos?.id).to(equal("12345"))
                        case let .failure(error):
                            fail("Expected call to createUserStatus to succeed but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("getUserStatus()") {
            it("should make API call to get all Terms of Service User Statuses when call is successful") {
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/terms_of_service_user_statuses")
                        && isMethodGET()
                        && containsQueryParams(["tos_id": "12345", "user_id": "88888"])
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("GetTermsOfServiceUserStatuses.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.termsOfService.getUserStatus(tosId: "12345", userId: "88888") { result in
                        switch result {
                        case let .success(userStatus):
                            expect(userStatus).to(beAKindOf(TermsOfServiceUserStatus.self))
                        case let .failure(error):
                            fail("Expected call to getUserStatus to succeed, but it got \(error)")
                        }
                        done()
                    }
                }
            }
        }

        describe("updateUserStatus()") {
            it("should make API call to update a user status for a Terms of Service when call is successful") {
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/terms_of_service_user_statuses/88888")
                        && isMethodPUT()
                        && hasJsonBody([
                            "is_accepted": true
                        ])
                ) { _ in
                    OHHTTPStubsResponse(
                        fileAtPath: OHPathForFile("FullTermsOfServiceUserStatus.json", type(of: self))!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: 10) { done in
                    self.sut.termsOfService.updateUserStatus(userStatusId: "88888", isAccepted: true) { result in
                        switch result {
                        case let .success(userStatus):
                            expect(userStatus).to(beAKindOf(TermsOfServiceUserStatus.self))
                            expect(userStatus.id).to(equal("88888"))
                            expect(userStatus.type).to(equal("terms_of_service_user_status"))
                            expect(userStatus.tos?.id).to(equal("12345"))
                        case let .failure(error):
                            fail("Expected call to succeed, but it got \(error)")
                        }
                        done()
                    }
                }
            }
        }
    }
}
