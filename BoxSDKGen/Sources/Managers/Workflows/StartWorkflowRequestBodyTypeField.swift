import Foundation

public enum StartWorkflowRequestBodyTypeField: CodableStringEnum {
    case workflowParameters
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "workflow_parameters".lowercased():
            self = .workflowParameters
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .workflowParameters:
            return "workflow_parameters"
        case .customValue(let value):
            return value
        }
    }

}
