import Foundation
import BoxSdkGen
import XCTest

class AiStudioManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testAiStudioCrud() async throws {
        let agentName: String = Utils.getUUID()
        let createdAgent: AiSingleAgentResponseFull = try await client.aiStudio.createAiAgent(requestBody: CreateAiAgent(name: agentName, accessState: "enabled", ask: AiStudioAgentAsk(accessState: "enabled", description: "desc1")))
        XCTAssertTrue(createdAgent.name == agentName)
        let agents: AiMultipleAgentResponse = try await client.aiStudio.getAiAgents()
        let numAgents: Int = agents.entries.count
        XCTAssertTrue(Utils.Strings.toString(value: agents.entries[0].type) == "ai_agent")
        let retrievedAgent: AiSingleAgentResponseFull = try await client.aiStudio.getAiAgentById(agentId: createdAgent.id, queryParams: GetAiAgentByIdQueryParams(fields: ["ask"]))
        XCTAssertTrue(retrievedAgent.name == agentName)
        XCTAssertTrue(Utils.Strings.toString(value: retrievedAgent.accessState) == "enabled")
        XCTAssertTrue(Utils.Strings.toString(value: retrievedAgent.ask!.accessState) == "enabled")
        XCTAssertTrue(retrievedAgent.ask!.description == "desc1")
        let updatedAgent: AiSingleAgentResponseFull = try await client.aiStudio.updateAiAgentById(agentId: createdAgent.id, requestBody: CreateAiAgent(name: agentName, accessState: "enabled", ask: AiStudioAgentAsk(accessState: "disabled", description: "desc2")))
        XCTAssertTrue(Utils.Strings.toString(value: updatedAgent.accessState) == "enabled")
        XCTAssertTrue(Utils.Strings.toString(value: updatedAgent.ask!.accessState) == "disabled")
        XCTAssertTrue(updatedAgent.ask!.description == "desc2")
        try await client.aiStudio.deleteAiAgentById(agentId: createdAgent.id)
        let agentsAfterDelete: AiMultipleAgentResponse = try await client.aiStudio.getAiAgents()
        XCTAssertTrue(agentsAfterDelete.entries.count == numAgents - 1)
    }
}
