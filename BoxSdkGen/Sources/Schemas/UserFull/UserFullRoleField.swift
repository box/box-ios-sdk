import Foundation

public enum UserFullRoleField: CodableStringEnum {
    case admin
    case coadmin
    case user
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "admin".lowercased():
            self = .admin
        case "coadmin".lowercased():
            self = .coadmin
        case "user".lowercased():
            self = .user
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .admin:
            return "admin"
        case .coadmin:
            return "coadmin"
        case .user:
            return "user"
        case .customValue(let value):
            return value
        }
    }

}
