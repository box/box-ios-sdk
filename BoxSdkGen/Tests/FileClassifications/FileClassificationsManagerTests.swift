import Foundation
import BoxSdkGen
import XCTest

class FileClassificationsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func getOrCreateSecondClassification(classificationTemplate: ClassificationTemplate) async throws -> ClassificationTemplateFieldsOptionsField {
        let classifications: [ClassificationTemplateFieldsOptionsField] = classificationTemplate.fields[0].options
        let currentNumberOfClassifications: Int = classifications.count
        if currentNumberOfClassifications == 1 {
            let classificationTemplateWithNewClassification: ClassificationTemplate = try await client.classifications.addClassification(requestBody: [AddClassificationRequestBody(data: AddClassificationRequestBodyDataField(key: Utils.getUUID(), staticConfig: AddClassificationRequestBodyDataStaticConfigField(classification: AddClassificationRequestBodyDataStaticConfigClassificationField(classificationDefinition: "Other description", colorId: Int64(4)))))])
            return classificationTemplateWithNewClassification.fields[0].options[1]
        }

        return classifications[1]
    }

    public func testFileClassifications() async throws {
        let classificationTemplate: ClassificationTemplate = try await CommonsManager().getOrCreateClassificationTemplate()
        let classification: ClassificationTemplateFieldsOptionsField = try await CommonsManager().getOrCreateClassification(classificationTemplate: classificationTemplate)
        let file: FileFull = try await CommonsManager().uploadNewFile()
        await XCTAssertThrowsErrorAsync(try await client.fileClassifications.getClassificationOnFile(fileId: file.id))
        let createdFileClassification: Classification = try await client.fileClassifications.addClassificationToFile(fileId: file.id, requestBody: AddClassificationToFileRequestBody(boxSecurityClassificationKey: classification.key))
        XCTAssertTrue(createdFileClassification.boxSecurityClassificationKey == classification.key)
        let fileClassification: Classification = try await client.fileClassifications.getClassificationOnFile(fileId: file.id)
        XCTAssertTrue(fileClassification.boxSecurityClassificationKey == classification.key)
        let secondClassification: ClassificationTemplateFieldsOptionsField = try await getOrCreateSecondClassification(classificationTemplate: classificationTemplate)
        let updatedFileClassification: Classification = try await client.fileClassifications.updateClassificationOnFile(fileId: file.id, requestBody: [UpdateClassificationOnFileRequestBody(value: secondClassification.key)])
        XCTAssertTrue(updatedFileClassification.boxSecurityClassificationKey == secondClassification.key)
        try await client.fileClassifications.deleteClassificationFromFile(fileId: file.id)
        await XCTAssertThrowsErrorAsync(try await client.fileClassifications.getClassificationOnFile(fileId: file.id))
        try await client.files.deleteFileById(fileId: file.id)
    }
}
