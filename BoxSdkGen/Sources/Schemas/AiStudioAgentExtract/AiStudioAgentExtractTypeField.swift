import Foundation

public enum AiStudioAgentExtractTypeField: CodableStringEnum {
    case aiAgentExtract
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ai_agent_extract".lowercased():
            self = .aiAgentExtract
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .aiAgentExtract:
            return "ai_agent_extract"
        case .customValue(let value):
            return value
        }
    }

}
