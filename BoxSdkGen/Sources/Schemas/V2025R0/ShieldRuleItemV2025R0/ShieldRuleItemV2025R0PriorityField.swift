import Foundation

public enum ShieldRuleItemV2025R0PriorityField: CodableStringEnum {
    case informational
    case low
    case medium
    case high
    case critical
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "informational".lowercased():
            self = .informational
        case "low".lowercased():
            self = .low
        case "medium".lowercased():
            self = .medium
        case "high".lowercased():
            self = .high
        case "critical".lowercased():
            self = .critical
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .informational:
            return "informational"
        case .low:
            return "low"
        case .medium:
            return "medium"
        case .high:
            return "high"
        case .critical:
            return "critical"
        case .customValue(let value):
            return value
        }
    }

}
