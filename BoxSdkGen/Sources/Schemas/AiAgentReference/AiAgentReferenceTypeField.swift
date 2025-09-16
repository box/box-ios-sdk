import Foundation

public enum AiAgentReferenceTypeField: CodableStringEnum {
    case aiAgentId
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ai_agent_id".lowercased():
            self = .aiAgentId
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .aiAgentId:
            return "ai_agent_id"
        case .customValue(let value):
            return value
        }
    }

}
