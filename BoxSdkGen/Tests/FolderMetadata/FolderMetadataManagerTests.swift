import Foundation
import BoxSdkGen
import XCTest

class FolderMetadataManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testGlobalFolderMetadata() async throws {
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let folderMetadata: Metadatas = try await client.folderMetadata.getFolderMetadata(folderId: folder.id)
        XCTAssertTrue(folderMetadata.entries!.count == 0)
        let createdMetadata: MetadataFull = try await client.folderMetadata.createFolderMetadataById(folderId: folder.id, scope: CreateFolderMetadataByIdScope.global, templateKey: "properties", requestBody: ["abc": "xyz"])
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.template) == "properties")
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.scope) == "global")
        XCTAssertTrue(createdMetadata.version == 0)
        let receivedMetadata: MetadataFull = try await client.folderMetadata.getFolderMetadataById(folderId: folder.id, scope: GetFolderMetadataByIdScope.global, templateKey: "properties")
        XCTAssertTrue(Utils.Strings.toString(value: receivedMetadata.extraData!["abc"]) == "xyz")
        try await client.folderMetadata.deleteFolderMetadataById(folderId: folder.id, scope: DeleteFolderMetadataByIdScope.global, templateKey: "properties")
        await XCTAssertThrowsErrorAsync(try await client.folderMetadata.getFolderMetadataById(folderId: folder.id, scope: GetFolderMetadataByIdScope.global, templateKey: "properties"))
        try await client.folders.deleteFolderById(folderId: folder.id)
    }

    public func testEnterpriseFolderMetadata() async throws {
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let templateKey: String = "\("key")\(Utils.getUUID())"
        let template: MetadataTemplate = try await client.metadataTemplates.createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody(scope: "enterprise", displayName: templateKey, templateKey: templateKey, fields: [CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.string, key: "name", displayName: "name"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.float, key: "age", displayName: "age"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.date, key: "birthDate", displayName: "birthDate"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.enum_, key: "countryCode", displayName: "countryCode", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "US"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "CA")]), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.multiSelect, key: "sports", displayName: "sports", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "basketball"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "football"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "tennis")])]))
        let createdMetadata: MetadataFull = try await client.folderMetadata.createFolderMetadataById(folderId: folder.id, scope: CreateFolderMetadataByIdScope.enterprise, templateKey: templateKey, requestBody: ["name": "John", "age": 23, "birthDate": "2001-01-03T02:20:50.520Z", "countryCode": "US", "sports": ["basketball", "tennis"]])
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.template) == templateKey)
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.extraData!["name"]) == "John")
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.extraData!["age"]) == "23")
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.extraData!["birthDate"]) == "2001-01-03T02:20:50.520Z")
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.extraData!["countryCode"]) == "US")
        try await client.folderMetadata.deleteFolderMetadataById(folderId: folder.id, scope: DeleteFolderMetadataByIdScope.enterprise, templateKey: templateKey)
        try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: templateKey)
        try await client.folders.deleteFolderById(folderId: folder.id)
    }
}
