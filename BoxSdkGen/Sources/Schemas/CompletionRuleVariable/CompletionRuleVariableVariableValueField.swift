import Foundation

public enum CompletionRuleVariableVariableValueField: CodableStringEnum {
    case allAssignees
    case anyAssignees
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "all_assignees".lowercased():
            self = .allAssignees
        case "any_assignees".lowercased():
            self = .anyAssignees
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .allAssignees:
            return "all_assignees"
        case .anyAssignees:
            return "any_assignees"
        case .customValue(let value):
            return value
        }
    }

}
