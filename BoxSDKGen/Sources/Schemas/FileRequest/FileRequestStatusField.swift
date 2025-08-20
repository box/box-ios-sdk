import Foundation

public enum FileRequestStatusField: CodableStringEnum {
    case active
    case inactive
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "active".lowercased():
            self = .active
        case "inactive".lowercased():
            self = .inactive
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .customValue(let value):
            return value
        }
    }

}
