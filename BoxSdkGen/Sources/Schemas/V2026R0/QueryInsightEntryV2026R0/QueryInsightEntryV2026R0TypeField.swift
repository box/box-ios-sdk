import Foundation

public enum QueryInsightEntryV2026R0TypeField: CodableStringEnum {
    case group
    case overall
    case other
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "group".lowercased():
            self = .group
        case "overall".lowercased():
            self = .overall
        case "other".lowercased():
            self = .other
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .group:
            return "group"
        case .overall:
            return "overall"
        case .other:
            return "other"
        case .customValue(let value):
            return value
        }
    }

}
