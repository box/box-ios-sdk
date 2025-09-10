import Foundation

public enum GroupMembershipTypeField: CodableStringEnum {
    case groupMembership
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "group_membership".lowercased():
            self = .groupMembership
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .groupMembership:
            return "group_membership"
        case .customValue(let value):
            return value
        }
    }

}
