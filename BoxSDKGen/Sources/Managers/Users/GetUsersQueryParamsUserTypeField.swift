import Foundation

public enum GetUsersQueryParamsUserTypeField: CodableStringEnum {
    case all
    case managed
    case external
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "all".lowercased():
            self = .all
        case "managed".lowercased():
            self = .managed
        case "external".lowercased():
            self = .external
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .all:
            return "all"
        case .managed:
            return "managed"
        case .external:
            return "external"
        case .customValue(let value):
            return value
        }
    }

}
