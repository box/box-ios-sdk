import Foundation

public enum StoragePolicyAssignmentTypeField: CodableStringEnum {
    case storagePolicyAssignment
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "storage_policy_assignment".lowercased():
            self = .storagePolicyAssignment
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .storagePolicyAssignment:
            return "storage_policy_assignment"
        case .customValue(let value):
            return value
        }
    }

}
