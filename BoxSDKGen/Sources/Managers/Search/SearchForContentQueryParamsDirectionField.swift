import Foundation

public enum SearchForContentQueryParamsDirectionField: CodableStringEnum {
    case desc
    case asc
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "DESC".lowercased():
            self = .desc
        case "ASC".lowercased():
            self = .asc
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .desc:
            return "DESC"
        case .asc:
            return "ASC"
        case .customValue(let value):
            return value
        }
    }

}
