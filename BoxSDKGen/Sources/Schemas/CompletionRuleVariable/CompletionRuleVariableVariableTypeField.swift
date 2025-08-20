import Foundation

public enum CompletionRuleVariableVariableTypeField: CodableStringEnum {
    case taskCompletionRule
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "task_completion_rule".lowercased():
            self = .taskCompletionRule
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .taskCompletionRule:
            return "task_completion_rule"
        case .customValue(let value):
            return value
        }
    }

}
