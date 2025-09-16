import Foundation

public enum UpdateGroupByIdRequestBodyInvitabilityLevelField: CodableStringEnum {
    case adminsOnly
    case adminsAndMembers
    case allManagedUsers
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "admins_only".lowercased():
            self = .adminsOnly
        case "admins_and_members".lowercased():
            self = .adminsAndMembers
        case "all_managed_users".lowercased():
            self = .allManagedUsers
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .adminsOnly:
            return "admins_only"
        case .adminsAndMembers:
            return "admins_and_members"
        case .allManagedUsers:
            return "all_managed_users"
        case .customValue(let value):
            return value
        }
    }

}
