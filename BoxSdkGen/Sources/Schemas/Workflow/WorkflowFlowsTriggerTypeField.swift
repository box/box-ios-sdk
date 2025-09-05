import Foundation

public enum WorkflowFlowsTriggerTypeField: CodableStringEnum {
    case trigger
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "trigger".lowercased():
            self = .trigger
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .trigger:
            return "trigger"
        case .customValue(let value):
            return value
        }
    }

}
