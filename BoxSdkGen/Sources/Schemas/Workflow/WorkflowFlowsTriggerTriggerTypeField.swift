import Foundation

public enum WorkflowFlowsTriggerTriggerTypeField: CodableStringEnum {
    case workflowManualStart
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "WORKFLOW_MANUAL_START".lowercased():
            self = .workflowManualStart
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .workflowManualStart:
            return "WORKFLOW_MANUAL_START"
        case .customValue(let value):
            return value
        }
    }

}
