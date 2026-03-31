import Foundation

public enum HubItemListBlockV2025R0TypeField: CodableStringEnum {
    case itemList
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "item_list".lowercased():
            self = .itemList
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .itemList:
            return "item_list"
        case .customValue(let value):
            return value
        }
    }

}
