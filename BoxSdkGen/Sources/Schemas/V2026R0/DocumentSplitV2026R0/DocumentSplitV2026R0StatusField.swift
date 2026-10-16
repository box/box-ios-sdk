import Foundation

public enum DocumentSplitV2026R0StatusField: CodableStringEnum {
    case submitted
    case completed
    case failed
    case completedWithError
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
        case .customValue(let value):
            return value
        }
    }

}
