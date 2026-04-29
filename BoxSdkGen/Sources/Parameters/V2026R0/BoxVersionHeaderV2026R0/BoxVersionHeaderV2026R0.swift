import Foundation

public enum BoxVersionHeaderV2026R0: CodableStringEnum {
    case _20260
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "2026.0".lowercased():
            self = ._20260
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case ._20260:
            return "2026.0"
        case .customValue(let value):
            return value
        }
    }

}
