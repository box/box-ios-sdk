import Foundation

public enum AppItemTypeField: CodableStringEnum {
    case appItem
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "app_item".lowercased():
            self = .appItem
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .appItem:
            return "app_item"
        case .customValue(let value):
            return value
        }
    }

}
