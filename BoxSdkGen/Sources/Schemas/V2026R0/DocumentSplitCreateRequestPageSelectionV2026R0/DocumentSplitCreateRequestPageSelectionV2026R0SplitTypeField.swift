import Foundation

public enum DocumentSplitCreateRequestPageSelectionV2026R0SplitTypeField: CodableStringEnum {
    case pageSelection
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "page_selection".lowercased():
            self = .pageSelection
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .pageSelection:
            return "page_selection"
        case .customValue(let value):
            return value
        }
    }

}
