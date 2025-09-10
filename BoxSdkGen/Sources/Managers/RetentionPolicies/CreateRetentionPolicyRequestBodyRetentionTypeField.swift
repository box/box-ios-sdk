import Foundation

public enum CreateRetentionPolicyRequestBodyRetentionTypeField: CodableStringEnum {
    case modifiable
    case nonModifiable
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "modifiable".lowercased():
            self = .modifiable
        case "non_modifiable".lowercased():
            self = .nonModifiable
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .modifiable:
            return "modifiable"
        case .nonModifiable:
            return "non_modifiable"
        case .customValue(let value):
            return value
        }
    }

}
