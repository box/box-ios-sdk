import Foundation

public enum FileFullLockAppTypeField: CodableStringEnum {
    case gsuite
    case officeWopi
    case officeWopiplus
    case other
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "gsuite".lowercased():
            self = .gsuite
        case "office_wopi".lowercased():
            self = .officeWopi
        case "office_wopiplus".lowercased():
            self = .officeWopiplus
        case "other".lowercased():
            self = .other
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .gsuite:
            return "gsuite"
        case .officeWopi:
            return "office_wopi"
        case .officeWopiplus:
            return "office_wopiplus"
        case .other:
            return "other"
        case .customValue(let value):
            return value
        }
    }

}
