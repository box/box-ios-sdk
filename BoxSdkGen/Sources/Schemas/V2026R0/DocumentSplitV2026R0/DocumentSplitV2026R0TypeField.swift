import Foundation

public enum DocumentSplitV2026R0TypeField: CodableStringEnum {
    case documentSplit
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "document_split".lowercased():
            self = .documentSplit
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .documentSplit:
            return "document_split"
        case .customValue(let value):
            return value
        }
    }

}
