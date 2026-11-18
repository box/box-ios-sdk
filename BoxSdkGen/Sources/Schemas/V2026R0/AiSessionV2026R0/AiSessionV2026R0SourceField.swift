import Foundation

public enum AiSessionV2026R0SourceField: CodableStringEnum {
    case api
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "api".lowercased():
            self = .api
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .api:
            return "api"
        case .customValue(let value):
            return value
        }
    }

}
