import Foundation

public enum DocumentSplitPageSelectionPageRangeV2026R0TypeField: CodableStringEnum {
    case pageRange
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "page_range".lowercased():
            self = .pageRange
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .pageRange:
            return "page_range"
        case .customValue(let value):
            return value
        }
    }

}
