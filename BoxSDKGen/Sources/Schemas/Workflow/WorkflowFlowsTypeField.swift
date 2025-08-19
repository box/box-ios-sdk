import Foundation

public enum WorkflowFlowsTypeField: CodableStringEnum {
    case flow
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "flow".lowercased():
            self = .flow
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .flow:
            return "flow"
        case .customValue(let value):
            return value
        }
    }

}
