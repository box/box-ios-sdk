import Foundation

public enum HubV2025R0CopyHubAccessField: CodableStringEnum {
    case all
    case company
    case none
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "all".lowercased():
            self = .all
        case "company".lowercased():
            self = .company
        case "none".lowercased():
            self = .none
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .all:
            return "all"
        case .company:
            return "company"
        case .none:
            return "none"
        case .customValue(let value):
            return value
        }
    }

}
