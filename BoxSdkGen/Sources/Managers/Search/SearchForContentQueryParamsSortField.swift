import Foundation

public enum SearchForContentQueryParamsSortField: CodableStringEnum {
    case modifiedAt
    case relevance
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "modified_at".lowercased():
            self = .modifiedAt
        case "relevance".lowercased():
            self = .relevance
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .modifiedAt:
            return "modified_at"
        case .relevance:
            return "relevance"
        case .customValue(let value):
            return value
        }
    }

}
