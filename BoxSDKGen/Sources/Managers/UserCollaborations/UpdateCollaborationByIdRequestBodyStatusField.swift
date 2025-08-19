import Foundation

public enum UpdateCollaborationByIdRequestBodyStatusField: CodableStringEnum {
    case pending
    case accepted
    case rejected
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "pending".lowercased():
            self = .pending
        case "accepted".lowercased():
            self = .accepted
        case "rejected".lowercased():
            self = .rejected
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .pending:
            return "pending"
        case .accepted:
            return "accepted"
        case .rejected:
            return "rejected"
        case .customValue(let value):
            return value
        }
    }

}
