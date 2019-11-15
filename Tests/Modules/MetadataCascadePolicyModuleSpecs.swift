//
//  MetadataCascadePolicyModuleSpecs.swift
//  BoxSDK
//
//  Created by Daniel Cech on 9/04/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class MetadataCascadePolicyModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        beforeEach {
            self.sut = BoxSDK.getClient(token: "asdads")
        }

        afterEach {
            OHHTTPStubs.removeAllStubs()
        }

        describe("MetadataCascadePolicyModule") {

            describe("list()") {
                it("should make API call to get list of metadata cascade policies when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/metadata_cascade_policies")
                            && isMethodGET()
                            && containsQueryParams(["owner_enterprise_id": "abcde", "folder_id": "12345"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetMetadataCascadePolicies.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadataCascadePolicy.list(folderId: "12345", ownerEnterpriseId: "abcde") { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
//                                    print("in iterator")
                                    switch result {
                                    case let .success(firstPolicy):
                                        expect(firstPolicy).to(beAKindOf(MetadataCascadePolicy.self))
                                        expect(firstPolicy.id).to(equal("84113349-794d-445c-b93c-d8481b223434"))
                                        expect(firstPolicy.scope?.description).to(equal("enterprise_11111"))
                                        expect(firstPolicy.templateKey).to(equal("testTemplate"))
                                        expect(firstPolicy.ownerEnterprise?.id).to(equal("11111"))

                                        guard let folder = firstPolicy.parent else {
                                            fail("Parent folder is not present")
                                            done()
                                            return
                                        }

                                        expect(folder.id).to(equal("22222"))
                                    case let .failure(error):
                                        fail("Expected call to list() to succeed, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Expected call to list() to succeed, but instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            describe("get()") {
                it("should make API call to get metadata cascade policy by ID and produce the model when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/metadata_cascade_policies/6fd4ff89-8fc1-42cf-8b29-1890dedd26d7")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetMetadataCascadePolicy.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadataCascadePolicy.get(id: "6fd4ff89-8fc1-42cf-8b29-1890dedd26d7") { result in
                            switch result {
                            case let .success(policy):
                                expect(policy).to(beAKindOf(MetadataCascadePolicy.self))
                                expect(policy.id).to(equal("84113349-794d-445c-b93c-d8481b223434"))
                                expect(policy.scope?.description).to(equal("enterprise_11111"))
                                expect(policy.templateKey).to(equal("testTemplate"))
                                expect(policy.ownerEnterprise?.id).to(equal("11111"))

                            case let .failure(error):
                                fail("Expected call to get() to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("create()") {
                it("should make API call to create metadata cascade policy when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/metadata_cascade_policies")
                            && isMethodPOST()
                            && hasJsonBody(["scope": "enterprise", "folder_id": "998951261", "templateKey": "documentFlow"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateMetadataCascadePolicy.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadataCascadePolicy.create(
                            folderId: "998951261",
                            scope: .enterprise,
                            templateKey: "documentFlow"
                        ) { result in
                            switch result {
                            case let .success(policy):
                                expect(policy).to(beAKindOf(MetadataCascadePolicy.self))
                                expect(policy.id).to(equal("84113349-794d-445c-b93c-d8481b223434"))
                                expect(policy.scope?.description).to(equal("enterprise_11111"))
                                expect(policy.templateKey).to(equal("testTemplate"))
                                expect(policy.ownerEnterprise?.id).to(equal("11111"))

                            case let .failure(error):
                                fail("Expected call to create() to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete()") {
                it("should make API call to delete metadata cascade policy when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/metadata_cascade_policies/123456") && isMethodDELETE()) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadataCascadePolicy.delete(id: "123456") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete() to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("forceApply()") {
                it("should make API call to force apply metadata cascade policy when API call succeeds") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/metadata_cascade_policies/12345/apply")
                            && isMethodPOST()
                            && hasJsonBody(["conflict_resolution": "overwrite"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadataCascadePolicy.forceApply(
                            id: "12345",
                            conflictResolution: .overwrite
                        ) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to forceApply() to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
