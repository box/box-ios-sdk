import Foundation

public enum TaskAssignmentTypeField: CodableStringEnum {
    case taskAssignment
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "task_assignment".lowercased():
            self = .taskAssignment
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .taskAssignment:
            return "task_assignment"
        case .customValue(let value):
            return value
        }
    }

}
