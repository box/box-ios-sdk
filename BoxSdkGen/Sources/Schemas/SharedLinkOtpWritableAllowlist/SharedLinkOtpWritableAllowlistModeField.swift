import Foundation

public enum SharedLinkOtpWritableAllowlistModeField: CodableStringEnum {
    case allowlist
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "allowlist".lowercased():
            self = .allowlist
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .allowlist:
            return "allowlist"
        case .customValue(let value):
            return value
        }
    }

}
