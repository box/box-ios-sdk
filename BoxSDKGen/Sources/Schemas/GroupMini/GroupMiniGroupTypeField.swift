import Foundation

public enum GroupMiniGroupTypeField: CodableStringEnum {
    case managedGroup
    case allUsersGroup
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "managed_group".lowercased():
            self = .managedGroup
        case "all_users_group".lowercased():
            self = .allUsersGroup
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .managedGroup:
            return "managed_group"
        case .allUsersGroup:
            return "all_users_group"
        case .customValue(let value):
            return value
        }
    }

}
