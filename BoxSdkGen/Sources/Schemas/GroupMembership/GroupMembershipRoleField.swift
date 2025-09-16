import Foundation

public enum GroupMembershipRoleField: CodableStringEnum {
    case member
    case admin
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "member".lowercased():
            self = .member
        case "admin".lowercased():
            self = .admin
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .member:
            return "member"
        case .admin:
            return "admin"
        case .customValue(let value):
            return value
        }
    }

}
