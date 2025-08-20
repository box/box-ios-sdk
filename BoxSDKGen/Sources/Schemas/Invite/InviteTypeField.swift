import Foundation

public enum InviteTypeField: CodableStringEnum {
    case invite
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "invite".lowercased():
            self = .invite
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .invite:
            return "invite"
        case .customValue(let value):
            return value
        }
    }

}
