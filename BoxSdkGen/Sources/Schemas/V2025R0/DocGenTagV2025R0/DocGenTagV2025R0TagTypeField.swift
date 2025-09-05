import Foundation

public enum DocGenTagV2025R0TagTypeField: CodableStringEnum {
    case text
    case arithmetic
    case conditional
    case forLoop
    case tableLoop
    case image
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "text".lowercased():
            self = .text
        case "arithmetic".lowercased():
            self = .arithmetic
        case "conditional".lowercased():
            self = .conditional
        case "for-loop".lowercased():
            self = .forLoop
        case "table-loop".lowercased():
            self = .tableLoop
        case "image".lowercased():
            self = .image
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .text:
            return "text"
        case .arithmetic:
            return "arithmetic"
        case .conditional:
            return "conditional"
        case .forLoop:
            return "for-loop"
        case .tableLoop:
            return "table-loop"
        case .image:
            return "image"
        case .customValue(let value):
            return value
        }
    }

}
