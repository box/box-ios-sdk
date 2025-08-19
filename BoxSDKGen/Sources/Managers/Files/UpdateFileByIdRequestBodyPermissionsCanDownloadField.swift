import Foundation

public enum UpdateFileByIdRequestBodyPermissionsCanDownloadField: CodableStringEnum {
    case open
    case company
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "open".lowercased():
            self = .open
        case "company".lowercased():
            self = .company
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .open:
            return "open"
        case .company:
            return "company"
        case .customValue(let value):
            return value
        }
    }

}
