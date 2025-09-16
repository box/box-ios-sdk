import Foundation

public enum UpdateSharedLinkOnFolderRequestBodySharedLinkAccessField: CodableStringEnum {
    case open
    case company
    case collaborators
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "open".lowercased():
            self = .open
        case "company".lowercased():
            self = .company
        case "collaborators".lowercased():
            self = .collaborators
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
        case .collaborators:
            return "collaborators"
        case .customValue(let value):
            return value
        }
    }

}
