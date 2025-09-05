import Foundation

public enum BoxVersionHeaderV2025R0: CodableStringEnum {
    case _20250
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "2025.0".lowercased():
            self = ._20250
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case ._20250:
            return "2025.0"
        case .customValue(let value):
            return value
        }
    }

}
