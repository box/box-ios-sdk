import Foundation

public enum DocGenJobV2025R0StatusField: CodableStringEnum {
    case submitted
    case completed
    case failed
    case completedWithError
    case pending
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "submitted".lowercased():
            self = .submitted
        case "completed".lowercased():
            self = .completed
        case "failed".lowercased():
            self = .failed
        case "completed_with_error".lowercased():
            self = .completedWithError
        case "pending".lowercased():
            self = .pending
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .submitted:
            return "submitted"
        case .completed:
            return "completed"
        case .failed:
            return "failed"
        case .completedWithError:
            return "completed_with_error"
        case .pending:
            return "pending"
        case .customValue(let value):
            return value
        }
    }

}
