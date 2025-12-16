import Foundation

public enum SignRequestSignerInputCustomValidationValidationTypeField: CodableStringEnum {
    case custom
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "custom".lowercased():
            self = .custom
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .custom:
            return "custom"
        case .customValue(let value):
            return value
        }
    }

}
