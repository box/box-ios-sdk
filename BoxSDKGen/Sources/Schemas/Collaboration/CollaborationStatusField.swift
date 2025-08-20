import Foundation

public enum CollaborationStatusField: CodableStringEnum {
    case accepted
    case pending
    case rejected
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "accepted".lowercased():
            self = .accepted
        case "pending".lowercased():
            self = .pending
        case "rejected".lowercased():
            self = .rejected
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .accepted:
            return "accepted"
        case .pending:
            return "pending"
        case .rejected:
            return "rejected"
        case .customValue(let value):
            return value
        }
    }

}
