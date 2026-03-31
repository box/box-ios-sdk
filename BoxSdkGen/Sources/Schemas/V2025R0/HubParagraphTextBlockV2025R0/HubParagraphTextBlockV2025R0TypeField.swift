import Foundation

public enum HubParagraphTextBlockV2025R0TypeField: CodableStringEnum {
    case paragraph
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "paragraph".lowercased():
            self = .paragraph
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .paragraph:
            return "paragraph"
        case .customValue(let value):
            return value
        }
    }

}
