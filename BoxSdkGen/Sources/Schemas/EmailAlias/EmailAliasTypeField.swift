import Foundation

public enum EmailAliasTypeField: CodableStringEnum {
    case emailAlias
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "email_alias".lowercased():
            self = .emailAlias
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .emailAlias:
            return "email_alias"
        case .customValue(let value):
            return value
        }
    }

}
