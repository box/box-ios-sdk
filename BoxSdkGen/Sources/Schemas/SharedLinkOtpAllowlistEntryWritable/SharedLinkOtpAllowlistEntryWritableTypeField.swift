import Foundation

public enum SharedLinkOtpAllowlistEntryWritableTypeField: CodableStringEnum {
    case email
    case domain
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "email".lowercased():
            self = .email
        case "domain".lowercased():
            self = .domain
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .email:
            return "email"
        case .domain:
            return "domain"
        case .customValue(let value):
            return value
        }
    }

}
