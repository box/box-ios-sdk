import Foundation

public enum SignRequestSignerVerificationMethodLoginTypeField: CodableStringEnum {
    case login
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "login".lowercased():
            self = .login
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .login:
            return "login"
        case .customValue(let value):
            return value
        }
    }

}
