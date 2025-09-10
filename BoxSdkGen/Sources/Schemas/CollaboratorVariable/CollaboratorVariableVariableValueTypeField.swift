import Foundation

public enum CollaboratorVariableVariableValueTypeField: CodableStringEnum {
    case user
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "user".lowercased():
            self = .user
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .user:
            return "user"
        case .customValue(let value):
            return value
        }
    }

}
