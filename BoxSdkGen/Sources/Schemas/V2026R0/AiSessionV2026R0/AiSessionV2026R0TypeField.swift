import Foundation

public enum AiSessionV2026R0TypeField: CodableStringEnum {
    case aiSession
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ai_session".lowercased():
            self = .aiSession
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .aiSession:
            return "ai_session"
        case .customValue(let value):
            return value
        }
    }

}
