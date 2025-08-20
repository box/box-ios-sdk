import Foundation

public enum CollaboratorVariableVariableTypeField: CodableStringEnum {
    case userList
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "user_list".lowercased():
            self = .userList
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .userList:
            return "user_list"
        case .customValue(let value):
            return value
        }
    }

}
