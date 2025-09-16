import Foundation

public enum SearchForContentQueryParamsTrashContentField: CodableStringEnum {
    case nonTrashedOnly
    case trashedOnly
    case allItems
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "non_trashed_only".lowercased():
            self = .nonTrashedOnly
        case "trashed_only".lowercased():
            self = .trashedOnly
        case "all_items".lowercased():
            self = .allItems
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .nonTrashedOnly:
            return "non_trashed_only"
        case .trashedOnly:
            return "trashed_only"
        case .allItems:
            return "all_items"
        case .customValue(let value):
            return value
        }
    }

}
