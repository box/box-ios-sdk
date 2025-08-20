import Foundation

public enum TrashFileRestoredItemStatusField: CodableStringEnum {
    case active
    case trashed
    case deleted
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "active".lowercased():
            self = .active
        case "trashed".lowercased():
            self = .trashed
        case "deleted".lowercased():
            self = .deleted
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .active:
            return "active"
        case .trashed:
            return "trashed"
        case .deleted:
            return "deleted"
        case .customValue(let value):
            return value
        }
    }

}
