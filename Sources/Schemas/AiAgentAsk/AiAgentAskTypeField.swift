import Foundation

public enum AiAgentAskTypeField: CodableStringEnum {
    case aiAgentAsk
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ai_agent_ask".lowercased():
            self = .aiAgentAsk
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .aiAgentAsk:
            return "ai_agent_ask"
        case .customValue(let value):
            return value
        }
    }

}
