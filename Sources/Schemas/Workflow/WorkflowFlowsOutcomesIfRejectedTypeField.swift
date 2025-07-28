import Foundation

public enum WorkflowFlowsOutcomesIfRejectedTypeField: CodableStringEnum {
    case outcome
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "outcome".lowercased():
            self = .outcome
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .outcome:
            return "outcome"
        case .customValue(let value):
            return value
        }
    }

}
