import Foundation

public enum GetAiSessionsV2026R0QueryParamsSortField: CodableStringEnum {
    case createdAt
    case updatedAt
    case name
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "created_at".lowercased():
            self = .createdAt
        case "updated_at".lowercased():
            self = .updatedAt
        case "name".lowercased():
            self = .name
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .createdAt:
            return "created_at"
        case .updatedAt:
            return "updated_at"
        case .name:
            return "name"
        case .customValue(let value):
            return value
        }
    }

}
