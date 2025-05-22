import Foundation

public enum RetentionPolicyAssignmentBaseTypeField: CodableStringEnum {
    case retentionPolicyAssignment
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "retention_policy_assignment".lowercased():
            self = .retentionPolicyAssignment
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .retentionPolicyAssignment:
            return "retention_policy_assignment"
        case .customValue(let value):
            return value
        }
    }

}
