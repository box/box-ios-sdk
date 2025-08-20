import Foundation

public enum AiAgentExtractStructuredTypeField: CodableStringEnum {
    case aiAgentExtractStructured
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ai_agent_extract_structured".lowercased():
            self = .aiAgentExtractStructured
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .aiAgentExtractStructured:
            return "ai_agent_extract_structured"
        case .customValue(let value):
            return value
        }
    }

}
