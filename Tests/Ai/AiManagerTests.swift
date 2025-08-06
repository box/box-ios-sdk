import Foundation
import BoxSdkGen
import XCTest

class AiManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testAskAiSingleItem() async throws {
        await runWithRetryAsync {
            let aiAgentConfig: AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen = try await client.ai.getAiAgentDefaultConfig(queryParams: GetAiAgentDefaultConfigQueryParams(mode: GetAiAgentDefaultConfigQueryParamsModeField.ask, language: "en-US"))
            let fileToAsk: FileFull = try await CommonsManager().uploadNewFile()
            let response: AiResponseFull? = try await client.ai.createAiAsk(requestBody: AiAsk(mode: AiAskModeField.singleItemQa, prompt: "which direction sun rises", items: [AiItemAsk(id: fileToAsk.id, type: AiItemAskTypeField.file, content: "Sun rises in the East")]))
            XCTAssertTrue(response!.answer.contains("East"))
            XCTAssertTrue(response!.completionReason == "done")
            try await client.files.deleteFileById(fileId: fileToAsk.id)
        }
    }

    public func testAskAiMultipleItems() async throws {
        await runWithRetryAsync {
            let fileToAsk1: FileFull = try await CommonsManager().uploadNewFile()
            let fileToAsk2: FileFull = try await CommonsManager().uploadNewFile()
            let response: AiResponseFull? = try await client.ai.createAiAsk(requestBody: AiAsk(mode: AiAskModeField.multipleItemQa, prompt: "Which direction sun rises?", items: [AiItemAsk(id: fileToAsk1.id, type: AiItemAskTypeField.file, content: "Earth goes around the sun"), AiItemAsk(id: fileToAsk2.id, type: AiItemAskTypeField.file, content: "Sun rises in the East in the morning")]))
            XCTAssertTrue(response!.answer.contains("East"))
            XCTAssertTrue(response!.completionReason == "done")
            try await client.files.deleteFileById(fileId: fileToAsk1.id)
            try await client.files.deleteFileById(fileId: fileToAsk2.id)
        }
    }

    public func testAiTextGenWithDialogueHistory() async throws {
        await runWithRetryAsync {
            let fileToAsk: FileFull = try await CommonsManager().uploadNewFile()
            let aiAgentConfig: AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen = try await client.ai.getAiAgentDefaultConfig(queryParams: GetAiAgentDefaultConfigQueryParams(mode: GetAiAgentDefaultConfigQueryParamsModeField.textGen, language: "en-US"))
            let response: AiResponse = try await client.ai.createAiTextGen(requestBody: AiTextGen(prompt: "Parapharse the document.s", items: [AiTextGenItemsField(id: fileToAsk.id, type: AiTextGenItemsTypeField.file, content: "The Earth goes around the sun. Sun rises in the East in the morning.")], dialogueHistory: [AiDialogueHistory(prompt: "What does the earth go around?", answer: "The sun", createdAt: try Utils.Dates.dateTimeFromString(dateTime: "2021-01-01T00:00:00Z")), AiDialogueHistory(prompt: "On Earth, where does the sun rise?", answer: "East", createdAt: try Utils.Dates.dateTimeFromString(dateTime: "2021-01-01T00:00:00Z"))]))
            XCTAssertTrue(response.answer.contains("sun"))
            XCTAssertTrue(response.completionReason == "done")
            try await client.files.deleteFileById(fileId: fileToAsk.id)
        }
    }

    public func testGettingAiAskAgentConfig() async throws {
        await runWithRetryAsync {
            let aiAgentConfig: AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen = try await client.ai.getAiAgentDefaultConfig(queryParams: GetAiAgentDefaultConfigQueryParams(mode: GetAiAgentDefaultConfigQueryParamsModeField.ask, language: "en-US"))
        }
    }

    public func testGettingAiTextGenAgentConfig() async throws {
        await runWithRetryAsync {
            let aiAgentConfig: AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen = try await client.ai.getAiAgentDefaultConfig(queryParams: GetAiAgentDefaultConfigQueryParams(mode: GetAiAgentDefaultConfigQueryParamsModeField.textGen, language: "en-US"))
        }
    }

    public func testAiExtract() async throws {
        await runWithRetryAsync {
            let aiAgentConfig: AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen = try await client.ai.getAiAgentDefaultConfig(queryParams: GetAiAgentDefaultConfigQueryParams(mode: GetAiAgentDefaultConfigQueryParamsModeField.extract, language: "en-US"))
            let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: "\(Utils.getUUID())\(".txt")", parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: Utils.stringToByteStream(text: "My name is John Doe. I live in San Francisco. I was born in 1990. I work at Box.")))
            let file: FileFull = uploadedFiles.entries![0]
            try await Utils.delayInSeconds(seconds: 5)
            let response: AiResponse = try await client.ai.createAiExtract(requestBody: AiExtract(prompt: "firstName, lastName, location, yearOfBirth, company", items: [AiItemBase(id: file.id)]))
            let expectedResponse: String = "{\"firstName\": \"John\", \"lastName\": \"Doe\", \"location\": \"San Francisco\", \"yearOfBirth\": \"1990\", \"company\": \"Box\"}"
            XCTAssertTrue(response.answer == expectedResponse)
            XCTAssertTrue(response.completionReason == "done")
            try await client.files.deleteFileById(fileId: file.id)
        }
    }

    public func testAiExtractStructuredWithFields() async throws {
        await runWithRetryAsync {
            let aiAgentConfig: AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen = try await client.ai.getAiAgentDefaultConfig(queryParams: GetAiAgentDefaultConfigQueryParams(mode: GetAiAgentDefaultConfigQueryParamsModeField.extractStructured, language: "en-US"))
            let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: "\(Utils.getUUID())\(".txt")", parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: Utils.stringToByteStream(text: "My name is John Doe. I was born in 4th July 1990. I am 34 years old. My hobby is guitar.")))
            let file: FileFull = uploadedFiles.entries![0]
            try await Utils.delayInSeconds(seconds: 5)
            let response: AiExtractStructuredResponse = try await client.ai.createAiExtractStructured(requestBody: AiExtractStructured(items: [AiItemBase(id: file.id)], fields: [AiExtractStructuredFieldsField(key: "firstName", description: "Person first name", displayName: "First name", prompt: "What is the your first name?", type: "string"), AiExtractStructuredFieldsField(key: "lastName", description: "Person last name", displayName: "Last name", prompt: "What is the your last name?", type: "string"), AiExtractStructuredFieldsField(key: "dateOfBirth", description: "Person date of birth", displayName: "Birth date", prompt: "What is the date of your birth?", type: "date"), AiExtractStructuredFieldsField(key: "age", description: "Person age", displayName: "Age", prompt: "How old are you?", type: "float"), AiExtractStructuredFieldsField(key: "hobby", description: "Person hobby", displayName: "Hobby", prompt: "What is your hobby?", type: "multiSelect", options: [AiExtractStructuredFieldsOptionsField(key: "guitar"), AiExtractStructuredFieldsOptionsField(key: "books")])]))
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.hobby")) == Utils.Strings.toString(value: ["guitar"]))
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.firstName")) == "John")
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.lastName")) == "Doe")
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.dateOfBirth")) == "1990-07-04")
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.age")) == "34")
            XCTAssertTrue(response.completionReason == "done")
            try await client.files.deleteFileById(fileId: file.id)
        }
    }

    public func testAiExtractStructuredWithMetadataTemplate() async throws {
        await runWithRetryAsync {
            let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: "\(Utils.getUUID())\(".txt")", parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: Utils.stringToByteStream(text: "My name is John Doe. I was born in 4th July 1990. I am 34 years old. My hobby is guitar.")))
            let file: FileFull = uploadedFiles.entries![0]
            try await Utils.delayInSeconds(seconds: 5)
            let templateKey: String = "\("key")\(Utils.getUUID())"
            let template: MetadataTemplate = try await client.metadataTemplates.createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody(scope: "enterprise", displayName: templateKey, templateKey: templateKey, fields: [CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.string, key: "firstName", displayName: "First name", description: "Person first name"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.string, key: "lastName", displayName: "Last name", description: "Person last name"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.date, key: "dateOfBirth", displayName: "Birth date", description: "Person date of birth"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.float, key: "age", displayName: "Age", description: "Person age"), CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.multiSelect, key: "hobby", displayName: "Hobby", description: "Person hobby", options: [CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "guitar"), CreateMetadataTemplateRequestBodyFieldsOptionsField(key: "books")])]))
            let response: AiExtractStructuredResponse = try await client.ai.createAiExtractStructured(requestBody: AiExtractStructured(items: [AiItemBase(id: file.id)], metadataTemplate: AiExtractStructuredMetadataTemplateField(templateKey: templateKey, scope: "enterprise")))
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.firstName")) == "John")
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.lastName")) == "Doe")
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.dateOfBirth")) == "1990-07-04T00:00:00Z")
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.age")) == "34")
            XCTAssertTrue(Utils.Strings.toString(value: Utils.getValueFromObjectRawData(obj: response, key: "answer.hobby")) == Utils.Strings.toString(value: ["guitar"]))
            XCTAssertTrue(response.completionReason == "done")
            try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: template.templateKey!)
            try await client.files.deleteFileById(fileId: file.id)
        }
    }
}
