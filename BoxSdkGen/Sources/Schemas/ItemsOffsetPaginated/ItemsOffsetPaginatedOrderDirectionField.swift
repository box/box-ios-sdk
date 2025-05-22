import Foundation

public enum ItemsOffsetPaginatedOrderDirectionField: CodableStringEnum {
    case asc
    case desc
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ASC".lowercased():
            self = .asc
        case "DESC".lowercased():
            self = .desc
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .asc:
            return "ASC"
        case .desc:
            return "DESC"
        case .customValue(let value):
            return value
        }
    }

}
