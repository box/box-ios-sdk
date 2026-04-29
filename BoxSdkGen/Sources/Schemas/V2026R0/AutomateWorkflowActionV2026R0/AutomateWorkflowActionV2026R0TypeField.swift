import Foundation

public enum AutomateWorkflowActionV2026R0TypeField: CodableStringEnum {
    case workflowAction
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "workflow_action".lowercased():
            self = .workflowAction
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .workflowAction:
            return "workflow_action"
        case .customValue(let value):
            return value
        }
    }

}
