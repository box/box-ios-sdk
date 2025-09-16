import Foundation

public enum TaskAssignmentResolutionStateField: CodableStringEnum {
    case completed
    case incomplete
    case approved
    case rejected
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "completed".lowercased():
            self = .completed
        case "incomplete".lowercased():
            self = .incomplete
        case "approved".lowercased():
            self = .approved
        case "rejected".lowercased():
            self = .rejected
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .completed:
            return "completed"
        case .incomplete:
            return "incomplete"
        case .approved:
            return "approved"
        case .rejected:
            return "rejected"
        case .customValue(let value):
            return value
        }
    }

}
