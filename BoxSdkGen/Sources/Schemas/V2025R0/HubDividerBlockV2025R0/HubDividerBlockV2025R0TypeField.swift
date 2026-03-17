import Foundation

public enum HubDividerBlockV2025R0TypeField: CodableStringEnum {
    case divider
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "divider".lowercased():
            self = .divider
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .divider:
            return "divider"
        case .customValue(let value):
            return value
        }
    }

}
