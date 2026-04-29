import Foundation

public enum AutomateWorkflowActionV2026R0ActionTypeField: CodableStringEnum {
    case runWorkflow
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "run_workflow".lowercased():
            self = .runWorkflow
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .runWorkflow:
            return "run_workflow"
        case .customValue(let value):
            return value
        }
    }

}
