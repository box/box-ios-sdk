import Foundation

public enum SignRequestSignerInputSsnValidationValidationTypeField: CodableStringEnum {
    case ssn
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ssn".lowercased():
            self = .ssn
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .ssn:
            return "ssn"
        case .customValue(let value):
            return value
        }
    }

}
