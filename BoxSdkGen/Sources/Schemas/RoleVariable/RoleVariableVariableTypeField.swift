import Foundation

public enum RoleVariableVariableTypeField: CodableStringEnum {
    case collaboratorRole
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "collaborator_role".lowercased():
            self = .collaboratorRole
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .collaboratorRole:
            return "collaborator_role"
        case .customValue(let value):
            return value
        }
    }

}
