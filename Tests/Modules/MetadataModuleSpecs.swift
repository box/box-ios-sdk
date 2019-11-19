//
//  BoxFileModulesSpecs.swift
//  BoxSDK
//
//  Created by Daniel Cech on 6/20/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class MetadataModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        beforeEach {
            self.sut = BoxSDK.getClient(token: "asdads")
        }

        afterEach {
            OHHTTPStubs.removeAllStubs()
        }

        describe("MetadataModule") {

            // MARK: - Metadata Templates

            describe("getTemplateByKey(scope:templateId:completion)") {
                it("should make API call to get metadata template by name and produce file model when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/metadata_templates/enterprise/productInfo/schema") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetMetadataTemplate.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.getTemplateByKey(scope: "enterprise", templateKey: "productInfo") { result in
                            switch result {
                            case let .success(template):
                                expect(template).toNot(beNil())
                                expect(template.id).to(equal("f7a9891f"))
                                expect(template.templateKey).to(equal("productInfo"))
                                expect(template.scope).to(equal("enterprise_12345"))
                                expect(template.displayName).to(equal("Product Info"))
                                expect(template.hidden).to(equal(false))

                                guard let firstField = template.fields?[0] else {
                                    fail()
                                    done()
                                    return
                                }

                                expect(firstField).toNot(beNil())
                                expect(firstField.id).to(equal("f7a9892f"))
                                expect(firstField.type).to(equal("float"))
                                expect(firstField.key).to(equal("skuNumber"))
                                expect(firstField.displayName).to(equal("SKU Number"))
                                expect(firstField.hidden).to(equal(false))

                            case let .failure(error):
                                fail("Expected call to getTemplateByKey to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getTemplateById(id:completion:)") {
                it("should make API call to get metadata template by id and produce file model when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/metadata_templates/f7a9891f") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetMetadataTemplate.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.getTemplateById(id: "f7a9891f") { result in
                            switch result {
                            case let .success(template):
                                expect(template).toNot(beNil())
                                expect(template.id).to(equal("f7a9891f"))
                                expect(template.templateKey).to(equal("productInfo"))
                                expect(template.scope).to(equal("enterprise_12345"))
                                expect(template.displayName).to(equal("Product Info"))
                                expect(template.hidden).to(equal(false))

                                guard let firstField = template.fields?[0] else {
                                    fail()
                                    done()
                                    return
                                }

                                expect(firstField).toNot(beNil())
                                expect(firstField.id).to(equal("f7a9892f"))
                                expect(firstField.type).to(equal("float"))
                                expect(firstField.key).to(equal("skuNumber"))
                                expect(firstField.displayName).to(equal("SKU Number"))
                                expect(firstField.hidden).to(equal(false))

                            case let .failure(error):
                                fail("Expected call to getTemplateId to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("createTemplate()") {
                it("should make API call to create metadata template and produce file model when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/metadata_templates/schema") && isMethodPOST()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateMetadataTemplate.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        let options: [[String: String]] = [
                            ["key": "FY11"],
                            ["key": "FY12"],
                            ["key": "FY13"],
                            ["key": "FY14"],
                            ["key": "FY15"]
                        ]

                        self.sut.metadata.createTemplate(
                            scope: "enterprise_490685",
                            templateKey: "customer",
                            displayName: "Customer",
                            hidden: false,
                            fields: [
                                MetadataField(id: nil, type: "string", key: "customerTeam", displayName: "Customer team", options: nil, hidden: false),
                                MetadataField(id: nil, type: "multiSelect", key: "fy", displayName: "FY", options: options, hidden: false)
                            ]
                        ) { result in
                            switch result {
                            case let .success(template):
                                expect(template).toNot(beNil())
                                expect(template.templateKey).to(equal("customer"))
                                expect(template.scope).to(equal("enterprise_490685"))
                                expect(template.displayName).to(equal("Customer"))

                                guard let firstField = template.fields?[0] else {
                                    fail()
                                    done()
                                    return
                                }

                                expect(firstField).toNot(beNil())
                                expect(firstField.type).to(equal("string"))
                                expect(firstField.key).to(equal("customerTeam"))
                                expect(firstField.displayName).to(equal("Customer team"))
                                expect(firstField.hidden).to(equal(false))

                                guard let secondField = template.fields?[1] else {
                                    fail()
                                    done()
                                    return
                                }

                                expect(secondField).toNot(beNil())
                                expect(secondField.type).to(equal("multiSelect"))
                                expect(secondField.key).to(equal("fy"))
                                expect(secondField.displayName).to(equal("FY"))
                                expect(secondField.hidden).to(equal(false))

                                guard let firstOption = secondField.options?[0] else {
                                    fail()
                                    done()
                                    return
                                }

                                expect(firstOption).toNot(beNil())
                                expect(firstOption["key"]).to(equal("FY11"))

                            case let .failure(error):
                                fail("Expected call to createTemplate to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("updateTemplate()") {
                it("should make API call to update metadata template and produce file model when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/metadata_templates/enterprise_490685/customer/schema") && isMethodPUT()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateMetadataTemplate.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.updateTemplate(
                            scope: "enterprise_490685",
                            templateKey: "customer",
                            operation: .editTemplate(data: ["displayName": "Client"])
                        ) { result in
                            switch result {
                            case let .success(template):
                                expect(template).toNot(beNil())
                                expect(template.templateKey).to(equal("customer"))
                                expect(template.scope).to(equal("enterprise_490685"))
                                expect(template.displayName).to(equal("Client"))

                                guard let firstField = template.fields?[0] else {
                                    fail()
                                    done()
                                    return
                                }

                                expect(firstField).toNot(beNil())
                                expect(firstField.type).to(equal("string"))
                                expect(firstField.key).to(equal("customerTeam"))
                                expect(firstField.displayName).to(equal("Customer team"))
                                expect(firstField.hidden).to(equal(false))

                                guard let secondField = template.fields?[1] else {
                                    fail()
                                    done()
                                    return
                                }

                                expect(secondField).toNot(beNil())
                                expect(secondField.type).to(equal("multiSelect"))
                                expect(secondField.key).to(equal("fy"))
                                expect(secondField.displayName).to(equal("FY"))
                                expect(secondField.hidden).to(equal(false))

                                guard let firstOption = secondField.options?[0] else {
                                    fail()
                                    done()
                                    return
                                }

                                expect(firstOption).toNot(beNil())
                                expect(firstOption["key"]).to(equal("FY11"))

                            case let .failure(error):
                                fail("Expected call to updateTemplate to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("deleteTemplate()") {
                it("should make API call to create metadata template and produce file model when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/metadata_templates/enterprise/vendorContract/schema") && isMethodDELETE()) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.deleteTemplate(
                            scope: "enterprise",
                            templateKey: "vendorContract"
                        ) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to updateTemplate to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listEnterpriseTemplates()") {
                it("should make API call to get enterprise metadata templates and produce file model when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/metadata_templates/enterprise") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetEnterpriseTemplates.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.listEnterpriseTemplates(scope: "enterprise") { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(firstTemplate):
                                        expect(firstTemplate).to(beAKindOf(MetadataTemplate.self))
                                        expect(firstTemplate.templateKey).to(equal("documentFlow"))
                                        expect(firstTemplate.scope).to(equal("enterprise_12345"))
                                        expect(firstTemplate.displayName).to(equal("Document Flow"))
                                        expect(firstTemplate.hidden).to(equal(false))

                                    case let .failure(error):
                                        fail("Expected call to listEnterpriseTemplates to succeed, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Expected call to listEnterpriseTemplates to succeed, but instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            // MARK: - File Metadata

            describe("list(forFileId)") {
                it("should make API call to get all metadata objects for particular file when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/5010739061/metadata") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetAllMetadataOnFile.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.list(forFileId: "5010739061") { result in
                            switch result {
                            case let .success(metadataObjects):
                                guard let firstMetadataObject = metadataObjects.first else {
                                    fail("Metadata object array is empty")
                                    done()
                                    return
                                }

                                expect(firstMetadataObject).to(beAKindOf(MetadataObject.self))
                                expect(firstMetadataObject.template).to(equal("documentFlow"))
                                expect(firstMetadataObject.scope).to(equal("enterprise_12345"))
                                expect(firstMetadataObject.type).to(equal("documentFlow-452b4c9d-c3ad-4ac7-b1ad-9d5192f2fc5f"))
                                expect(firstMetadataObject.parent).to(equal("file_5010739061"))
                                expect(firstMetadataObject.id).to(equal("50ba0dba-0f89-4395-b867-3e057c1f6ed9"))
                                expect(firstMetadataObject.version).to(equal(4))
                                expect(firstMetadataObject.typeVersion).to(equal(2))

                                guard let customKeys = firstMetadataObject.keys as? [String: String] else {
                                    fail("Unable to access custom keys")
                                    done()
                                    return
                                }

                                expect(customKeys["currentDocumentStage"]).to(equal("Init"))
                                expect(customKeys["needsApprovalFrom"]).to(equal("Smith"))

                            case let .failure(error):
                                fail("Expected call to list to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("get(forFileWithId:)") {
                it("should make API call to get metadata objects for particular file when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/5010739061/metadata/enterprise/marketingCollateral") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetMetadataOnFile.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.get(forFileWithId: "5010739061", scope: "enterprise", templateKey: "marketingCollateral") { result in
                            switch result {
                            case let .success(metadataObject):

                                expect(metadataObject).to(beAKindOf(MetadataObject.self))
                                expect(metadataObject.template).to(equal("marketingCollateral"))
                                expect(metadataObject.scope).to(equal("enterprise_12345"))
                                expect(metadataObject.type).to(equal("marketingCollateral-d086c908-2498-4d3e-8a1f-01e82bfc2abe"))
                                expect(metadataObject.parent).to(equal("file_5010739061"))
                                expect(metadataObject.id).to(equal("2094c584-68e1-475c-a581-534a4609594e"))
                                expect(metadataObject.version).to(equal(0))
                                expect(metadataObject.typeVersion).to(equal(0))

                                guard let customKeys = metadataObject.keys as? [String: String] else {
                                    fail("Unable to access custom keys")
                                    done()
                                    return
                                }

                                expect(customKeys["audience1"]).to(equal("internal"))
                                expect(customKeys["documentType"]).to(equal("Q1 plans"))
                                expect(customKeys["competitiveDocument"]).to(equal("no"))
                                expect(customKeys["status"]).to(equal("active"))
                                expect(customKeys["author"]).to(equal("Jones"))
                                expect(customKeys["currentState"]).to(equal("proposal"))

                            case let .failure(error):
                                fail("Expected call to get to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("create(forFileWithId:)") {
                it("should make API call to create metadata objects for particular file when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/5010739061/metadata/enterprise/marketingCollateral") && isMethodPOST()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateMetadataOnFile.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        let keys: [String: Any] = [
                            "audience1": "internal",
                            "documentType": "Q1 plans",
                            "competitiveDocument": "no",
                            "status": "active",
                            "author": "Jones",
                            "currentState": "proposal"
                        ]

                        self.sut.metadata.create(
                            forFileWithId: "5010739061",
                            scope: "enterprise",
                            templateKey: "marketingCollateral",
                            keys: keys
                        ) { result in
                            switch result {
                            case let .success(metadataObject):

                                expect(metadataObject).to(beAKindOf(MetadataObject.self))
                                expect(metadataObject.template).to(equal("marketingCollateral"))
                                expect(metadataObject.scope).to(equal("enterprise_12345"))
                                expect(metadataObject.type).to(equal("marketingCollateral-d086c908-2498-4d3e-8a1f-01e82bfc2abe"))
                                expect(metadataObject.parent).to(equal("file_5010739061"))
                                expect(metadataObject.id).to(equal("2094c584-68e1-475c-a581-534a4609594e"))
                                expect(metadataObject.version).to(equal(0))
                                expect(metadataObject.typeVersion).to(equal(0))

                                guard let customKeys = metadataObject.keys as? [String: String] else {
                                    fail("Unable to access custom keys")
                                    done()
                                    return
                                }

                                expect(customKeys["audience1"]).to(equal("internal"))
                                expect(customKeys["documentType"]).to(equal("Q1 plans"))
                                expect(customKeys["competitiveDocument"]).to(equal("no"))
                                expect(customKeys["status"]).to(equal("active"))
                                expect(customKeys["author"]).to(equal("Jones"))
                                expect(customKeys["currentState"]).to(equal("proposal"))

                            case let .failure(error):
                                fail("Expected call to create to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("update(forFileWithId:)") {
                it("should make API call to get metadata objects for particular file when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/5010739061/metadata/enterprise/marketingCollateral") && isMethodPUT()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateMetadataOnFile.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        let operations: [FileMetadataOperation] = [
                            .test(path: "/competitiveDocument", value: "no"),
                            .remove(path: "/competitiveDocument"),
                            .test(path: "/competitiveDocument", value: "no"),
                            .replace(path: "/status", value: "inactive"),
                            .test(path: "/author", value: "Jones"),
                            .copy(from: "/competitiveDocument", path: "/editor"),
                            .test(path: "/currentState", value: "proposal"),
                            .move(from: "/currentState", path: "/previousState"),
                            .add(path: "/currentState", value: "reviewed")
                        ]

                        self.sut.metadata.update(
                            forFileWithId: "5010739061",
                            scope: "enterprise",
                            templateKey: "marketingCollateral",
                            operations: operations
                        ) { result in
                            switch result {
                            case let .success(metadataObject):

                                expect(metadataObject).to(beAKindOf(MetadataObject.self))
                                expect(metadataObject.template).to(equal("marketingCollateral"))
                                expect(metadataObject.scope).to(equal("enterprise_12345"))
                                expect(metadataObject.type).to(equal("marketingCollateral-d086c908-2498-4d3e-8a1f-01e82bfc2abe"))
                                expect(metadataObject.parent).to(equal("file_5010739061"))
                                expect(metadataObject.id).to(equal("2094c584-68e1-475c-a581-534a4609594e"))
                                expect(metadataObject.version).to(equal(1))
                                expect(metadataObject.typeVersion).to(equal(0))

                                guard let customKeys = metadataObject.keys as? [String: String] else {
                                    fail("Unable to access custom keys")
                                    done()
                                    return
                                }

                                expect(customKeys["audience1"]).to(equal("internal"))
                                expect(customKeys["documentType"]).to(equal("Q1 plans"))
                                expect(customKeys["status"]).to(equal("inactive"))
                                expect(customKeys["author"]).to(equal("Jones"))
                                expect(customKeys["editor"]).to(equal("Jones"))
                                expect(customKeys["currentState"]).to(equal("reviewed"))

                            case let .failure(error):
                                fail("Expected call to update to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete(forFileWithId:)") {
                it("should make API call to delete metadata objects for particular file when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/files/5010739061/metadata/enterprise/marketingCollateral") && isMethodDELETE()) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.delete(
                            forFileWithId: "5010739061",
                            scope: "enterprise",
                            templateKey: "marketingCollateral"
                        ) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            // MARK: - Folder Metadata

            describe("list(forFolderId)") {
                it("should make API call to get all metadata objects for particular folder when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/998951261/metadata") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetAllMetadataOnFolder.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.list(forFolderId: "998951261") { result in
                            switch result {
                            case let .success(metadataObjects):
                                guard let firstMetadataObject = metadataObjects.first else {
                                    fail("Metadata object array is empty")
                                    done()
                                    return
                                }

                                expect(firstMetadataObject).to(beAKindOf(MetadataObject.self))
                                expect(firstMetadataObject.template).to(equal("documentFlow"))
                                expect(firstMetadataObject.scope).to(equal("enterprise_12345"))
                                expect(firstMetadataObject.type).to(equal("documentFlow-452b4c9d-c3ad-4ac7-b1ad-9d5192f2fc5f"))
                                expect(firstMetadataObject.parent).to(equal("folder_998951261"))
                                expect(firstMetadataObject.id).to(equal("e57f90ff-0044-48c2-807d-06b908765baf"))
                                expect(firstMetadataObject.version).to(equal(1))
                                expect(firstMetadataObject.typeVersion).to(equal(2))

                                expect(firstMetadataObject.keys["currentDocumentStage"] as? String).to(equal("prioritization"))
                                expect(firstMetadataObject.keys["needsApprovalFrom"] as? String).to(equal("planning team"))

                            case let .failure(error):
                                fail("Expected call to list to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("get(forFolderWithId:)") {
                it("should make API call to get metadata objects for particular folder when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/998951261/metadata/enterprise/documentFlow") && isMethodGET()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetMetadataOnFolder.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.get(forFolderWithId: "998951261", scope: "enterprise", templateKey: "documentFlow") { result in
                            switch result {
                            case let .success(metadataObject):

                                expect(metadataObject).to(beAKindOf(MetadataObject.self))
                                expect(metadataObject.template).to(equal("documentFlow"))
                                expect(metadataObject.scope).to(equal("enterprise_12345"))
                                expect(metadataObject.type).to(equal("documentFlow-452b4c9d-c3ad-4ac7-b1ad-9d5192f2fc5f"))
                                expect(metadataObject.parent).to(equal("folder_998951261"))
                                expect(metadataObject.id).to(equal("e57f90ff-0044-48c2-807d-06b908765baf"))
                                expect(metadataObject.version).to(equal(0))
                                expect(metadataObject.typeVersion).to(equal(2))

                                guard let customKeys = metadataObject.keys as? [String: String] else {
                                    fail("Unable to access custom keys")
                                    done()
                                    return
                                }

                                expect(customKeys["currentDocumentStage"]).to(equal("initial vetting"))
                                expect(customKeys["needsApprovalFrom"]).to(equal("vetting team"))
                                expect(customKeys["nextDocumentStage"]).to(equal("prioritization"))

                            case let .failure(error):
                                fail("Expected call to getto succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("create(forFolderWithId:)") {
                it("should make API call to create metadata objects for particular folder when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/998951261/metadata/enterprise/documentFlow") && isMethodPOST()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateMetadataOnFolder.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        let keys: [String: Any] = [
                            "currentDocumentStage": "initial vetting",
                            "needsApprovalFrom": "vetting team",
                            "nextDocumentStage": "prioritization"
                        ]

                        self.sut.metadata.create(
                            forFolderWithId: "998951261",
                            scope: "enterprise",
                            templateKey: "documentFlow",
                            keys: keys
                        ) { result in
                            switch result {
                            case let .success(metadataObject):

                                expect(metadataObject).to(beAKindOf(MetadataObject.self))
                                expect(metadataObject.template).to(equal("documentFlow"))
                                expect(metadataObject.scope).to(equal("enterprise_12345"))
                                expect(metadataObject.type).to(equal("documentFlow-452b4c9d-c3ad-4ac7-b1ad-9d5192f2fc5f"))
                                expect(metadataObject.parent).to(equal("folder_998951261"))
                                expect(metadataObject.id).to(equal("e57f90ff-0044-48c2-807d-06b908765baf"))
                                expect(metadataObject.version).to(equal(0))
                                expect(metadataObject.typeVersion).to(equal(0))

                                guard let customKeys = metadataObject.keys as? [String: String] else {
                                    fail("Unable to access custom keys")
                                    done()
                                    return
                                }

                                expect(customKeys["currentDocumentStage"]).to(equal("initial vetting"))
                                expect(customKeys["needsApprovalFrom"]).to(equal("vetting team"))
                                expect(customKeys["nextDocumentStage"]).to(equal("prioritization"))

                            case let .failure(error):
                                fail("Expected call to create to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("update(forFolderWithId:)") {
                it("should make API call to get metadata objects for particular folder when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/998951261/metadata/enterprise/documentFlow") && isMethodPUT()) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateMetadataOnFolder.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        let operations: [FolderMetadataOperation] = [
                            .test(path: "/currentDocumentStage", value: "initial vetting"),
                            .replace(path: "/currentDocumentStage", value: "prioritization"),
                            .test(path: "/needsApprovalFrom", value: "vetting team"),
                            .replace(path: "/needsApprovalFrom", value: "planning team"),
                            .add(path: "/maximumDaysAllowedInCurrentStage", value: "5"),
                            .test(path: "/nextDocumentStage", value: "prioritization"),
                            .remove(path: "/nextDocumentStage")
                        ]

                        self.sut.metadata.update(
                            forFolderWithId: "998951261",
                            scope: "enterprise",
                            templateKey: "documentFlow",
                            operations: operations
                        ) { result in
                            switch result {
                            case let .success(metadataObject):

                                expect(metadataObject).to(beAKindOf(MetadataObject.self))
                                expect(metadataObject.template).to(equal("documentFlow"))
                                expect(metadataObject.scope).to(equal("enterprise_12345"))
                                expect(metadataObject.type).to(equal("documentFlow-452b4c9d-c3ad-4ac7-b1ad-9d5192f2fc5f"))
                                expect(metadataObject.parent).to(equal("folder_998951261"))
                                expect(metadataObject.id).to(equal("e57f90ff-0044-48c2-807d-06b908765baf"))
                                expect(metadataObject.version).to(equal(1))
                                expect(metadataObject.typeVersion).to(equal(2))

                                expect(metadataObject.keys["currentDocumentStage"] as? String).to(equal("prioritization"))
                                expect(metadataObject.keys["needsApprovalFrom"] as? String).to(equal("planning team"))
                                expect(metadataObject.keys["maximumDaysAllowedInCurrentStage"] as? Int).to(equal(5))

                            case let .failure(error):
                                fail("Expected call to update to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete(forFolderWithId:)") {
                it("should make API call to delete metadata objects for particular folder when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/folders/998951261/metadata/enterprise/documentFlow") && isMethodDELETE()) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.metadata.delete(
                            forFolderWithId: "998951261",
                            scope: "enterprise",
                            templateKey: "documentFlow"
                        ) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
