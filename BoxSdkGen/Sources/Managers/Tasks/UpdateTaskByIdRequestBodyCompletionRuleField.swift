import Foundation

public enum UpdateTaskByIdRequestBodyCompletionRuleField: CodableStringEnum {
    case allAssignees
    case anyAssignee
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "all_assignees".lowercased():
            self = .allAssignees
        case "any_assignee".lowercased():
            self = .anyAssignee
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .allAssignees:
            return "all_assignees"
        case .anyAssignee:
            return "any_assignee"
        case .customValue(let value):
            return value
        }
    }

}
