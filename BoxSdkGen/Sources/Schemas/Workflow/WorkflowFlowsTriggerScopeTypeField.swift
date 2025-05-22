import Foundation

public enum WorkflowFlowsTriggerScopeTypeField: CodableStringEnum {
    case triggerScope
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "trigger_scope".lowercased():
            self = .triggerScope
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .triggerScope:
            return "trigger_scope"
        case .customValue(let value):
            return value
        }
    }

}
