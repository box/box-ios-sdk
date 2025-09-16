import Foundation

public enum SearchResultsTypeField: CodableStringEnum {
    case searchResultsItems
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "search_results_items".lowercased():
            self = .searchResultsItems
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .searchResultsItems:
            return "search_results_items"
        case .customValue(let value):
            return value
        }
    }

}
