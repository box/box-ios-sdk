import Foundation

public enum ShuttleReportV2026R0UsersScopeField: CodableStringEnum {
    case migrated
    case all
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "migrated".lowercased():
            self = .migrated
        case "all".lowercased():
            self = .all
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .migrated:
            return "migrated"
        case .all:
            return "all"
        case .customValue(let value):
            return value
        }
    }

}
