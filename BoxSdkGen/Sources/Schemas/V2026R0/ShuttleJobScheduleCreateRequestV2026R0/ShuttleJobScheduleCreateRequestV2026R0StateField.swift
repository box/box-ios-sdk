import Foundation

public enum ShuttleJobScheduleCreateRequestV2026R0StateField: CodableStringEnum {
    case enabled
    case paused
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "enabled".lowercased():
            self = .enabled
        case "paused".lowercased():
            self = .paused
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .enabled:
            return "enabled"
        case .paused:
            return "paused"
        case .customValue(let value):
            return value
        }
    }

}
