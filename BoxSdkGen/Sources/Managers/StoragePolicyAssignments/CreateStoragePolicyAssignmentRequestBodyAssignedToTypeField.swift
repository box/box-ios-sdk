import Foundation

public enum CreateStoragePolicyAssignmentRequestBodyAssignedToTypeField: CodableStringEnum {
    case user
    case enterprise
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "user".lowercased():
            self = .user
        case "enterprise".lowercased():
            self = .enterprise
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .user:
            return "user"
        case .enterprise:
            return "enterprise"
        case .customValue(let value):
            return value
        }
    }

}
