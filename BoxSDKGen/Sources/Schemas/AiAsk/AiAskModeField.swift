import Foundation

public enum AiAskModeField: CodableStringEnum {
    case multipleItemQa
    case singleItemQa
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "multiple_item_qa".lowercased():
            self = .multipleItemQa
        case "single_item_qa".lowercased():
            self = .singleItemQa
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .multipleItemQa:
            return "multiple_item_qa"
        case .singleItemQa:
            return "single_item_qa"
        case .customValue(let value):
            return value
        }
    }

}
