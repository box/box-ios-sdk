import Foundation

public enum CreateUserRequestBodyRoleField: CodableStringEnum {
    case coadmin
    case user
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
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
        case .coadmin:
            return "coadmin"
        case .user:
            return "user"
        case .customValue(let value):
            return value
        }
    }

}
