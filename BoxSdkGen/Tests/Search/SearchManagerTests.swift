import Foundation
import BoxSdkGen
import XCTest

class SearchManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateMetaDataQueryExecuteRead() async throws {
//        let templateKey: String = "\("key")\(Utils.getUUID())"
//        let template: MetadataTemplate = try await client.metadataTemplates.createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody(scope: "enterprise", displayName: templateKey, templateKey: templateKey, fields: [CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.string, key: "name", displayName: "name"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.float, key: "age", displayName: "age"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.date, key: "birthDate", displayName: "birthDate"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.enum_, key: "countryCode", displayName: "countryCode", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "US"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "CA")]), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.multiSelect, key: "sports", displayName: "sports", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "basketball"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "football"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "tennis")])]))
//        XCTAssertTrue(template.templateKey == templateKey)
//        let files: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: Utils.getUUID(), parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: Utils.generateByteStream(size: 10)))
//        let file: FileFull = files.entries![0]
//        let metadata: MetadataFull = try await client.fileMetadata.createFileMetadataById(fileId: file.id, scope: CreateFileMetadataByIdScope.enterprise, templateKey: templateKey, requestBody: ["name": "John", "age": 23, "birthDate": "2001-01-03T02:20:50.520Z", "countryCode": "US", "sports": ["basketball", "tennis"]])
//        XCTAssertTrue(metadata.template == templateKey)
//        XCTAssertTrue(metadata.scope == template.scope)
//        try await Utils.delayInSeconds(seconds: 5)
//        let searchFrom: String = "\(template.scope!)\(".")\(template.templateKey!)"
//        let query: MetadataQueryResults = try await client.search.searchByMetadataQuery(requestBody: MetadataQuery(from: searchFrom, ancestorFolderId: "0", query: "name = :name AND age < :age AND birthDate >= :birthDate AND countryCode = :countryCode AND sports = :sports", queryParams: ["name": "John", "age": 50, "birthDate": "2001-01-01T02:20:10.120Z", "countryCode": "US", "sports": ["basketball", "tennis"]]))
//        XCTAssertTrue(query.entries!.count >= 0)
//        try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: template.templateKey!)
//        try await client.files.deleteFileById(fileId: file.id)
//        
        
        let query: SearchResultsOrSearchResultsWithSharedLinks = try await client.search.searchForContent(queryParams: .init(mdfilters: [MetadataFilter(scope: .enterprise, templateKey: "sampleTemplate", filters: [
            "name" : .string("value")]
                                                                                                                                )
        ]))
    }
}

