import Foundation
import BoxSdkGen
import XCTest

class FileMetadataManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testGlobalFileMetadata() async throws {
        let file: FileFull = try await CommonsManager().uploadNewFile()
        let fileMetadata: Metadatas = try await client.fileMetadata.getFileMetadata(fileId: file.id)
        XCTAssertTrue(fileMetadata.entries!.count == 0)
        let createdMetadata: MetadataFull = try await client.fileMetadata.createFileMetadataById(fileId: file.id, scope: CreateFileMetadataByIdScope.global, templateKey: "properties", requestBody: ["abc": "xyz"])
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.template) == "properties")
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.scope) == "global")
        XCTAssertTrue(createdMetadata.version == 0)
        let receivedMetadata: MetadataFull = try await client.fileMetadata.getFileMetadataById(fileId: file.id, scope: GetFileMetadataByIdScope.global, templateKey: "properties")
        XCTAssertTrue(Utils.Strings.toString(value: receivedMetadata.extraData!["abc"]) == "xyz")
        try await client.fileMetadata.deleteFileMetadataById(fileId: file.id, scope: DeleteFileMetadataByIdScope.global, templateKey: "properties")
        await XCTAssertThrowsErrorAsync(try await client.fileMetadata.getFileMetadataById(fileId: file.id, scope: GetFileMetadataByIdScope.global, templateKey: "properties"))
        try await client.files.deleteFileById(fileId: file.id)
    }

    public func testEnterpriseFileMetadata() async throws {
        let file: FileFull = try await CommonsManager().uploadNewFile()
        let templateKey: String = "\("key")\(Utils.getUUID())"
        try await client.metadataTemplates.createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody(scope: "enterprise", displayName: templateKey, templateKey: templateKey, fields: [CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.string, key: "name", displayName: "name"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.float, key: "age", displayName: "age"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.date, key: "birthDate", displayName: "birthDate"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.enum_, key: "countryCode", displayName: "countryCode", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "US"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "CA")]), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.multiSelect, key: "sports", displayName: "sports", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "basketball"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "football"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "tennis")])]))
        let createdMetadata: MetadataFull = try await client.fileMetadata.createFileMetadataById(fileId: file.id, scope: CreateFileMetadataByIdScope.enterprise, templateKey: templateKey, requestBody: ["name": "John", "age": 23, "birthDate": "2001-01-03T02:20:50.520Z", "countryCode": "US", "sports": ["basketball", "tennis"]])
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.template) == templateKey)
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.extraData!["name"]) == "John")
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.extraData!["age"]) == "23")
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.extraData!["birthDate"]) == "2001-01-03T02:20:50.520Z")
        XCTAssertTrue(Utils.Strings.toString(value: createdMetadata.extraData!["countryCode"]) == "US")
        try await client.fileMetadata.deleteFileMetadataById(fileId: file.id, scope: DeleteFileMetadataByIdScope.enterprise, templateKey: templateKey)
        try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: templateKey)
        try await client.files.deleteFileById(fileId: file.id)
    }
}
