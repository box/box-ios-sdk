import Foundation

public enum CreateTermsOfServiceRequestBodyStatusField: CodableStringEnum {
    case enabled
    case disabled
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "enabled".lowercased():
            self = .enabled
        case "disabled".lowercased():
            self = .disabled
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .enabled:
            return "enabled"
        case .disabled:
            return "disabled"
        case .customValue(let value):
            return value
        }
    }

}
