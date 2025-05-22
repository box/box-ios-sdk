import Foundation
import BoxSdkGen
import XCTest

class MetadataTemplatesManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testMetadataTemplates() async throws {
        let templateKey: String = "\("key")\(Utils.getUUID())"
        let template: MetadataTemplate = try await client.metadataTemplates.createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody(scope: "enterprise", displayName: templateKey, templateKey: templateKey, fields: [CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.string, key: "testName", displayName: "testName"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.float, key: "age", displayName: "age"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.date, key: "birthDate", displayName: "birthDate"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.enum_, key: "countryCode", displayName: "countryCode", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "US"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "CA")]), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.multiSelect, key: "sports", displayName: "sports", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "basketball"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "football"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "tennis")])]))
        XCTAssertTrue(template.templateKey == templateKey)
        XCTAssertTrue(template.displayName == templateKey)
        XCTAssertTrue(template.fields!.count == 5)
        XCTAssertTrue(template.fields![0].key == "testName")
        XCTAssertTrue(template.fields![0].displayName == "testName")
        XCTAssertTrue(Utils.Strings.toString(value: template.fields![0].type) == "string")
        XCTAssertTrue(template.fields![1].key == "age")
        XCTAssertTrue(template.fields![1].displayName == "age")
        XCTAssertTrue(Utils.Strings.toString(value: template.fields![1].type) == "float")
        XCTAssertTrue(template.fields![2].key == "birthDate")
        XCTAssertTrue(template.fields![2].displayName == "birthDate")
        XCTAssertTrue(Utils.Strings.toString(value: template.fields![2].type) == "date")
        XCTAssertTrue(template.fields![3].key == "countryCode")
        XCTAssertTrue(template.fields![3].displayName == "countryCode")
        XCTAssertTrue(Utils.Strings.toString(value: template.fields![3].type) == "enum")
        XCTAssertTrue(template.fields![4].key == "sports")
        XCTAssertTrue(template.fields![4].displayName == "sports")
        XCTAssertTrue(Utils.Strings.toString(value: template.fields![4].type) == "multiSelect")
        let updatedTemplate: MetadataTemplate = try await client.metadataTemplates.updateMetadataTemplate(scope: UpdateMetadataTemplateScope.enterprise, templateKey: templateKey, requestBody: [UpdateMetadataTemplateRequestBody(op: UpdateMetadataTemplateRequestBodyOpField.addField, data: ["type": "string", "displayName": "newFieldName"], fieldKey: "newfieldname")])
        XCTAssertTrue(updatedTemplate.fields!.count == 6)
        XCTAssertTrue(updatedTemplate.fields![5].key == "newfieldname")
        XCTAssertTrue(updatedTemplate.fields![5].displayName == "newFieldName")
        let getMetadataTemplate: MetadataTemplate = try await client.metadataTemplates.getMetadataTemplateById(templateId: template.id)
        XCTAssertTrue(getMetadataTemplate.id == template.id)
        let getMetadataTemplateSchema: MetadataTemplate = try await client.metadataTemplates.getMetadataTemplate(scope: GetMetadataTemplateScope.enterprise, templateKey: template.templateKey!)
        XCTAssertTrue(getMetadataTemplateSchema.id == template.id)
        let enterpriseMetadataTemplates: MetadataTemplates = try await client.metadataTemplates.getEnterpriseMetadataTemplates()
        XCTAssertTrue(enterpriseMetadataTemplates.entries!.count > 0)
        let globalMetadataTemplates: MetadataTemplates = try await client.metadataTemplates.getGlobalMetadataTemplates()
        XCTAssertTrue(globalMetadataTemplates.entries!.count > 0)
        try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: template.templateKey!)
        await XCTAssertThrowsErrorAsync(try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: template.templateKey!))
    }

    public func testGetMetadataTemplateByInstance() async throws {
        let file: FileFull = try await CommonsManager().uploadNewFile()
        let templateKey: String = "\("key")\(Utils.getUUID())"
        let template: MetadataTemplate = try await client.metadataTemplates.createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody(scope: "enterprise", displayName: templateKey, templateKey: templateKey, fields: [CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.string, key: "testName", displayName: "testName")]))
        let createdMetadataInstance: MetadataFull = try await client.fileMetadata.createFileMetadataById(fileId: file.id, scope: CreateFileMetadataByIdScope.enterprise, templateKey: templateKey, requestBody: ["testName": "xyz"])
        let metadataTemplates: MetadataTemplates = try await client.metadataTemplates.getMetadataTemplatesByInstanceId(queryParams: GetMetadataTemplatesByInstanceIdQueryParams(metadataInstanceId: createdMetadataInstance.id!))
        XCTAssertTrue(metadataTemplates.entries!.count == 1)
        XCTAssertTrue(metadataTemplates.entries![0].displayName == templateKey)
        XCTAssertTrue(metadataTemplates.entries![0].templateKey == templateKey)
        try await client.fileMetadata.deleteFileMetadataById(fileId: file.id, scope: DeleteFileMetadataByIdScope.enterprise, templateKey: templateKey)
        try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: template.templateKey!)
        try await client.files.deleteFileById(fileId: file.id)
    }
}
