import Foundation

public enum LegalHoldPolicyStatusField: CodableStringEnum {
    case active
    case applying
    case releasing
    case released
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "active".lowercased():
            self = .active
        case "applying".lowercased():
            self = .applying
        case "releasing".lowercased():
            self = .releasing
        case "released".lowercased():
            self = .released
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .active:
            return "active"
        case .applying:
            return "applying"
        case .releasing:
            return "releasing"
        case .released:
            return "released"
        case .customValue(let value):
            return value
        }
    }

}
