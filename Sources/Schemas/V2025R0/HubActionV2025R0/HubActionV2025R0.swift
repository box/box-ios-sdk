import Foundation

/// The action to perform on a Hub item.
public enum HubActionV2025R0: CodableStringEnum {
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
