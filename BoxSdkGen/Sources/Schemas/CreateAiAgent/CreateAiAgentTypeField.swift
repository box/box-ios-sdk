import Foundation

public enum CreateAiAgentTypeField: CodableStringEnum {
    case aiAgent
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ai_agent".lowercased():
            self = .aiAgent
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .aiAgent:
            return "ai_agent"
        case .customValue(let value):
            return value
        }
    }

}
