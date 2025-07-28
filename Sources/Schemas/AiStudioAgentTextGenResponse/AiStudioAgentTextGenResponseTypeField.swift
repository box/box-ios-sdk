import Foundation

public enum AiStudioAgentTextGenResponseTypeField: CodableStringEnum {
    case aiAgentTextGen
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ai_agent_text_gen".lowercased():
            self = .aiAgentTextGen
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .aiAgentTextGen:
            return "ai_agent_text_gen"
        case .customValue(let value):
            return value
        }
    }

}
