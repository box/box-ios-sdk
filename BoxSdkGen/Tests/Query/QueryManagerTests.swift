import Foundation
import BoxSdkGen
import XCTest

class QueryManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateQueryV2026R0() async throws {
        await runWithRetryAsync {
            let templateKey: String = "\("key")\(Utils.getUUID())"
            let template: MetadataTemplate = try await client.metadataTemplates.createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody(scope: "enterprise", displayName: templateKey, templateKey: templateKey, fields: [CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.string, key: "name", displayName: "name"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.float, key: "age", displayName: "age"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.date, key: "birthDate", displayName: "birthDate")]))
            XCTAssertTrue(template.templateKey == templateKey)
            let file: FileFull = try await CommonsManager().uploadNewFile()
            let metadata: MetadataFull = try await client.fileMetadata.createFileMetadataById(fileId: file.id, scope: CreateFileMetadataByIdScope.enterprise, templateKey: templateKey, requestBody: ["name": "John", "age": 23, "birthDate": "2001-01-03T02:20:50.520Z"])
            XCTAssertTrue(metadata.template == templateKey)
            XCTAssertTrue(metadata.scope == template.scope)
            try await Utils.delayInSeconds(seconds: 10)
            let searchFrom: String = "\(template.scope!)\(":")\(template.templateKey!)"
            let mdPrefix: String = "\("metadata.")\(template.scope!)\(".\"")\(template.templateKey!)\("\"")"
            let predicate: String = "\(mdPrefix)\(".name = :name AND ")\(mdPrefix)\(".age < :age")"
            let queryResult: QueryResultsV2026R0 = try await client.query.createQueryV2026R0(requestBody: QueryRequestBodyV2026R0(query: QueryRequestBodyV2026R0QueryField(predicate: predicate, params: ["name": "John", "age": 50], ancestors: [QueryAncestorReferenceV2026R0(id: "0", type: "folder")]), limit: 10, fields: ["box:item:name", searchFrom]))
            XCTAssertTrue(queryResult.entries.count >= 0)
            try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: template.templateKey!)
            try await client.files.deleteFileById(fileId: file.id)
        }
    }

    public func testCreateQueryInsightV2026R0() async throws {
        await runWithRetryAsync {
            let templateKey: String = "\("key")\(Utils.getUUID())"
            let template: MetadataTemplate = try await client.metadataTemplates.createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody(scope: "enterprise", displayName: templateKey, templateKey: templateKey, fields: [CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.enum_, key: "category", displayName: "category", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "Sales"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "Support")]), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.float, key: "amount", displayName: "amount")]))
            XCTAssertTrue(template.templateKey == templateKey)
            let file: FileFull = try await CommonsManager().uploadNewFile()
            let metadata: MetadataFull = try await client.fileMetadata.createFileMetadataById(fileId: file.id, scope: CreateFileMetadataByIdScope.enterprise, templateKey: templateKey, requestBody: ["category": "Sales", "amount": 150])
            XCTAssertTrue(metadata.template == templateKey)
            try await Utils.delayInSeconds(seconds: 5)
            let mdPrefix: String = "\("metadata.")\(template.scope!)\(".\"")\(template.templateKey!)\("\"")"
            let predicate: String = "\(mdPrefix)\(".amount > :minAmount")"
            let metrics: [String: QueryInsightsMetricDefinitionV2026R0] = ["totalAmount": QueryInsightsMetricDefinitionV2026R0(type: QueryInsightsMetricDefinitionV2026R0TypeField.sum, field: "\(mdPrefix)\(".amount")"), "countItems": QueryInsightsMetricDefinitionV2026R0(type: QueryInsightsMetricDefinitionV2026R0TypeField.count, field: "\(mdPrefix)\(".category")")]
            let insightResult: QueryInsightsV2026R0 = try await client.query.createQueryInsightV2026R0(requestBody: QueryInsightsRequestBodyV2026R0(query: QueryInsightsRequestBodyV2026R0QueryField(predicate: predicate, params: ["minAmount": 0], ancestors: [QueryAncestorReferenceV2026R0(id: "0", type: "folder")], groupBy: [QueryInsightsGroupByV2026R0(field: "\(mdPrefix)\(".category")", bucketLimit: 5)]), metrics: metrics))
            XCTAssertTrue(insightResult.insights.count >= 0)
            try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: template.templateKey!)
            try await client.files.deleteFileById(fileId: file.id)
        }
    }
}
