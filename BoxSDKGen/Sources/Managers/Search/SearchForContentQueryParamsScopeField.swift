import Foundation

public enum SearchForContentQueryParamsScopeField: CodableStringEnum {
    case userContent
    case enterpriseContent
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "user_content".lowercased():
            self = .userContent
        case "enterprise_content".lowercased():
            self = .enterpriseContent
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .userContent:
            return "user_content"
        case .enterpriseContent:
            return "enterprise_content"
        case .customValue(let value):
            return value
        }
    }

}
