import Foundation

public enum SearchResultsWithSharedLinksTypeField: CodableStringEnum {
    case searchResultsWithSharedLinks
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "search_results_with_shared_links".lowercased():
            self = .searchResultsWithSharedLinks
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .searchResultsWithSharedLinks:
            return "search_results_with_shared_links"
        case .customValue(let value):
            return value
        }
    }

}
