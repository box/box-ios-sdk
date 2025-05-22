import Foundation
import BoxSdkGen
import XCTest

class ClassificationsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testClassifications() async throws {
        let classificationTemplate: ClassificationTemplate = try await CommonsManager().getOrCreateClassificationTemplate()
        let classification: ClassificationTemplateFieldsOptionsField = try await CommonsManager().getOrCreateClassification(classificationTemplate: classificationTemplate)
        XCTAssertTrue(classification.key != "")
        XCTAssertTrue(classification.staticConfig!.classification!.colorId != 100)
        XCTAssertTrue(classification.staticConfig!.classification!.classificationDefinition != "")
        let updatedClassificationName: String = Utils.getUUID()
        let updatedClassificationDescription: String = Utils.getUUID()
        let classificationTemplateWithUpdatedClassification: ClassificationTemplate = try await client.classifications.updateClassification(requestBody: [UpdateClassificationRequestBody(enumOptionKey: classification.key, data: UpdateClassificationRequestBodyDataField(key: updatedClassificationName, staticConfig: UpdateClassificationRequestBodyDataStaticConfigField(classification: UpdateClassificationRequestBodyDataStaticConfigClassificationField(classificationDefinition: updatedClassificationDescription, colorId: Int64(2)))))])
        let updatedClassifications: [ClassificationTemplateFieldsOptionsField] = classificationTemplateWithUpdatedClassification.fields[0].options
        let updatedClassification: ClassificationTemplateFieldsOptionsField = updatedClassifications[0]
        XCTAssertTrue(updatedClassification.key == updatedClassificationName)
        XCTAssertTrue(updatedClassification.staticConfig!.classification!.colorId == 2)
        XCTAssertTrue(updatedClassification.staticConfig!.classification!.classificationDefinition == updatedClassificationDescription)
    }
}
