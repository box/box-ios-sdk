import Foundation
import BoxSdkGen
import XCTest

class FolderClassificationsManagerTests: XCTestCase {
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

    public func testFolderClassifications() async throws {
        let classificationTemplate: ClassificationTemplate = try await CommonsManager().getOrCreateClassificationTemplate()
        let classification: ClassificationTemplateFieldsOptionsField = try await CommonsManager().getOrCreateClassification(classificationTemplate: classificationTemplate)
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        await XCTAssertThrowsErrorAsync(try await client.folderClassifications.getClassificationOnFolder(folderId: folder.id))
        let createdFolderClassification: Classification = try await client.folderClassifications.addClassificationToFolder(folderId: folder.id, requestBody: AddClassificationToFolderRequestBody(boxSecurityClassificationKey: classification.key))
        XCTAssertTrue(createdFolderClassification.boxSecurityClassificationKey == classification.key)
        let folderClassification: Classification = try await client.folderClassifications.getClassificationOnFolder(folderId: folder.id)
        XCTAssertTrue(folderClassification.boxSecurityClassificationKey == classification.key)
        let secondClassification: ClassificationTemplateFieldsOptionsField = try await getOrCreateSecondClassification(classificationTemplate: classificationTemplate)
        let updatedFolderClassification: Classification = try await client.folderClassifications.updateClassificationOnFolder(folderId: folder.id, requestBody: [UpdateClassificationOnFolderRequestBody(value: secondClassification.key)])
        XCTAssertTrue(updatedFolderClassification.boxSecurityClassificationKey == secondClassification.key)
        try await client.folderClassifications.deleteClassificationFromFolder(folderId: folder.id)
        await XCTAssertThrowsErrorAsync(try await client.folderClassifications.getClassificationOnFolder(folderId: folder.id))
        try await client.folders.deleteFolderById(folderId: folder.id)
    }
}
