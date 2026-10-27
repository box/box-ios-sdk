import Foundation

public enum ShuttleJobScheduleTriggerByTimeV2026R0TypeField: CodableStringEnum {
    case byTime
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "by_time".lowercased():
            self = .byTime
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .byTime:
            return "by_time"
        case .customValue(let value):
            return value
        }
    }

}
