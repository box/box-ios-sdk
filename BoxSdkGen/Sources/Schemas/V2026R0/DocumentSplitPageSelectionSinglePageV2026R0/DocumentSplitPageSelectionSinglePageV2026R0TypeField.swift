import Foundation

public enum DocumentSplitPageSelectionSinglePageV2026R0TypeField: CodableStringEnum {
    case singlePage
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "single_page".lowercased():
            self = .singlePage
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .singlePage:
            return "single_page"
        case .customValue(let value):
            return value
        }
    }

}
