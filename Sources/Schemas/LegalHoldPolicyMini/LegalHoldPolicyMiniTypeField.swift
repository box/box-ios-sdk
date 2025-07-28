import Foundation

public enum LegalHoldPolicyMiniTypeField: CodableStringEnum {
    case legalHoldPolicy
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "legal_hold_policy".lowercased():
            self = .legalHoldPolicy
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .legalHoldPolicy:
            return "legal_hold_policy"
        case .customValue(let value):
            return value
        }
    }

}
