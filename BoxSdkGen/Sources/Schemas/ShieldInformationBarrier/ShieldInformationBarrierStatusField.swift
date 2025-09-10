import Foundation

public enum ShieldInformationBarrierStatusField: CodableStringEnum {
    case draft
    case pending
    case disabled
    case enabled
    case invalid
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "draft".lowercased():
            self = .draft
        case "pending".lowercased():
            self = .pending
        case "disabled".lowercased():
            self = .disabled
        case "enabled".lowercased():
            self = .enabled
        case "invalid".lowercased():
            self = .invalid
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .draft:
            return "draft"
        case .pending:
            return "pending"
        case .disabled:
            return "disabled"
        case .enabled:
            return "enabled"
        case .invalid:
            return "invalid"
        case .customValue(let value):
            return value
        }
    }

}
