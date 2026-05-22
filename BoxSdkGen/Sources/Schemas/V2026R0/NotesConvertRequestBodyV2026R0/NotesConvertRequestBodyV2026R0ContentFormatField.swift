import Foundation

public enum NotesConvertRequestBodyV2026R0ContentFormatField: CodableStringEnum {
    case markdown
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "markdown".lowercased():
            self = .markdown
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .markdown:
            return "markdown"
        case .customValue(let value):
            return value
        }
    }

}
