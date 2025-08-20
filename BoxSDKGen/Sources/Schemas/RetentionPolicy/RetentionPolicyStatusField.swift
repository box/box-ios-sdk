import Foundation

public enum RetentionPolicyStatusField: CodableStringEnum {
    case active
    case retired
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "active".lowercased():
            self = .active
        case "retired".lowercased():
            self = .retired
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .active:
            return "active"
        case .retired:
            return "retired"
        case .customValue(let value):
            return value
        }
    }

}
