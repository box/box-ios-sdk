import Foundation

public enum FileFullRepresentationsEntriesStatusStateField: CodableStringEnum {
    case success
    case viewable
    case pending
    case none
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "success".lowercased():
            self = .success
        case "viewable".lowercased():
            self = .viewable
        case "pending".lowercased():
            self = .pending
        case "none".lowercased():
            self = .none
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .success:
            return "success"
        case .viewable:
            return "viewable"
        case .pending:
            return "pending"
        case .none:
            return "none"
        case .customValue(let value):
            return value
        }
    }

}
