import Foundation

public enum PostOAuth2TokenBoxSubjectTypeField: CodableStringEnum {
    case enterprise
    case user
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "enterprise".lowercased():
            self = .enterprise
        case "user".lowercased():
            self = .user
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .enterprise:
            return "enterprise"
        case .user:
            return "user"
        case .customValue(let value):
            return value
        }
    }

}
