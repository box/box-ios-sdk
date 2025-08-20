import Foundation

public enum CreateCollaborationRequestBodyAccessibleByTypeField: CodableStringEnum {
    case user
    case group
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "user".lowercased():
            self = .user
        case "group".lowercased():
            self = .group
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .user:
            return "user"
        case .group:
            return "group"
        case .customValue(let value):
            return value
        }
    }

}
