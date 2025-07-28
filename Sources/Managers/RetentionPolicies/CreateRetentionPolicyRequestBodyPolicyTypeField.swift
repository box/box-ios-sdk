import Foundation

public enum CreateRetentionPolicyRequestBodyPolicyTypeField: CodableStringEnum {
    case finite
    case indefinite
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "finite".lowercased():
            self = .finite
        case "indefinite".lowercased():
            self = .indefinite
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .finite:
            return "finite"
        case .indefinite:
            return "indefinite"
        case .customValue(let value):
            return value
        }
    }

}
