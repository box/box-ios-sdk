import Foundation
import BoxSdkGen
import XCTest

class AiManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testAskAiSingleItem() async throws {
        let fileToAsk: FileFull = try await CommonsManager().uploadNewFile()
        let response: AiResponseFull? = try await client.ai.createAiAsk(requestBody: AiAsk(mode: AiAskModeField.singleItemQa, prompt: "which direction sun rises", items: [AiItemAsk(id: fileToAsk.id, type: AiItemAskTypeField.file, content: "Sun rises in the East")]))
        XCTAssertTrue(response!.answer.contains("East"))
        XCTAssertTrue(response!.completionReason == "done")
        try await client.files.deleteFileById(fileId: fileToAsk.id)
    }

    public func testAskAiMultipleItems() async throws {
        let fileToAsk1: FileFull = try await CommonsManager().uploadNewFile()
        let fileToAsk2: FileFull = try await CommonsManager().uploadNewFile()
        let response: AiResponseFull? = try await client.ai.createAiAsk(requestBody: AiAsk(mode: AiAskModeField.multipleItemQa, prompt: "Which direction sun rises?", items: [AiItemAsk(id: fileToAsk1.id, type: AiItemAskTypeField.file, content: "Earth goes around the sun"), AiItemAsk(id: fileToAsk2.id, type: AiItemAskTypeField.file, content: "Sun rises in the East in the morning")]))
        XCTAssertTrue(response!.answer.contains("East"))
        XCTAssertTrue(response!.completionReason == "done")
        try await client.files.deleteFileById(fileId: fileToAsk1.id)
        try await client.files.deleteFileById(fileId: fileToAsk2.id)
    }

    public func testAiTextGenWithDialogueHistory() async throws {
        let fileToAsk: FileFull = try await CommonsManager().uploadNewFile()
        let response: AiResponse = try await client.ai.createAiTextGen(requestBody: AiTextGen(prompt: "Parapharse the document.s", items: [AiTextGenItemsField(id: fileToAsk.id, type: AiTextGenItemsTypeField.file, content: "The Earth goes around the sun. Sun rises in the East in the morning.")], dialogueHistory: [AiDialogueHistory(prompt: "What does the earth go around?", answer: "The sun", createdAt: try Utils.Dates.dateTimeFromString(dateTime: "2021-01-01T00:00:00Z")), AiDialogueHistory(prompt: "On Earth, where does the sun rise?", answer: "East", createdAt: try Utils.Dates.dateTimeFromString(dateTime: "2021-01-01T00:00:00Z"))]))
        XCTAssertTrue(response.answer.contains("sun"))
        XCTAssertTrue(response.completionReason == "done")
        try await client.files.deleteFileById(fileId: fileToAsk.id)
    }

    public func testGettingAiAskAgentConfig() async throws {
        let aiAskConfig: AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen = try await client.ai.getAiAgentDefaultConfig(queryParams: GetAiAgentDefaultConfigQueryParams(mode: GetAiAgentDefaultConfigQueryParamsModeField.ask, language: "en-US"))
    }

    public func testGettingAiTextGenAgentConfig() async throws {
        let aiTextGenConfig: AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen = try await client.ai.getAiAgentDefaultConfig(queryParams: GetAiAgentDefaultConfigQueryParams(mode: GetAiAgentDefaultConfigQueryParamsModeField.textGen, language: "en-US"))
    }

    public func testAiExtract() async throws {
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
