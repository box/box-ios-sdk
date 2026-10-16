import Foundation

public enum SharedLinkOtpWritableOpenModeField: CodableStringEnum {
    case open
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "open".lowercased():
            self = .open
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .open:
            return "open"
        case .customValue(let value):
            return value
        }
    }

}
