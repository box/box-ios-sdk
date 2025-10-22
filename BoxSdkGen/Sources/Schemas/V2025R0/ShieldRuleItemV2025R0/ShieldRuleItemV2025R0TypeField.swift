import Foundation

public enum ShieldRuleItemV2025R0TypeField: CodableStringEnum {
    case shieldRule
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shield_rule".lowercased():
            self = .shieldRule
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shieldRule:
            return "shield_rule"
        case .customValue(let value):
            return value
        }
    }

}
