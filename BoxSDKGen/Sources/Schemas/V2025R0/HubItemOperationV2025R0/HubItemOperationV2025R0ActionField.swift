import Foundation

public enum HubItemOperationV2025R0ActionField: CodableStringEnum {
    case add
    case remove
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "add".lowercased():
            self = .add
        case "remove".lowercased():
            self = .remove
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .add:
            return "add"
        case .remove:
            return "remove"
        case .customValue(let value):
            return value
        }
    }

}
