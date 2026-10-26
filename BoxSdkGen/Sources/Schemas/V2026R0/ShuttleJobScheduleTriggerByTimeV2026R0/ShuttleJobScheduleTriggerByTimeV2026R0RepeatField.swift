import Foundation

public enum ShuttleJobScheduleTriggerByTimeV2026R0RepeatField: CodableStringEnum {
    case none
    case daily
    case weekly
    case weekdays
    case weekends
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "none".lowercased():
            self = .none
        case "daily".lowercased():
            self = .daily
        case "weekly".lowercased():
            self = .weekly
        case "weekdays".lowercased():
            self = .weekdays
        case "weekends".lowercased():
            self = .weekends
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .none:
            return "none"
        case .daily:
            return "daily"
        case .weekly:
            return "weekly"
        case .weekdays:
            return "weekdays"
        case .weekends:
            return "weekends"
        case .customValue(let value):
            return value
        }
    }

}
