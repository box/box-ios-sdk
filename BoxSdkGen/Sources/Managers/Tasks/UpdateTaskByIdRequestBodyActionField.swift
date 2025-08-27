import Foundation

public enum UpdateTaskByIdRequestBodyActionField: CodableStringEnum {
    case review
    case complete
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "review".lowercased():
            self = .review
        case "complete".lowercased():
            self = .complete
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .review:
            return "review"
        case .complete:
            return "complete"
        case .customValue(let value):
            return value
        }
    }

}
