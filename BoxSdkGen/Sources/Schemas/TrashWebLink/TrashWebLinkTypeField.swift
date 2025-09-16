import Foundation

public enum TrashWebLinkTypeField: CodableStringEnum {
    case webLink
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "web_link".lowercased():
            self = .webLink
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .webLink:
            return "web_link"
        case .customValue(let value):
            return value
        }
    }

}
