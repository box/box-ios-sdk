import Foundation

public enum LegalHoldPolicyAssignmentBaseTypeField: CodableStringEnum {
    case legalHoldPolicyAssignment
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "legal_hold_policy_assignment".lowercased():
            self = .legalHoldPolicyAssignment
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .legalHoldPolicyAssignment:
            return "legal_hold_policy_assignment"
        case .customValue(let value):
            return value
        }
    }

}
