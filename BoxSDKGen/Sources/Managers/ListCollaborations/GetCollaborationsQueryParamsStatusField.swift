import Foundation

public enum GetCollaborationsQueryParamsStatusField: CodableStringEnum {
    case pending
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "pending".lowercased():
            self = .pending
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .pending:
            return "pending"
        case .customValue(let value):
            return value
        }
    }

}
