import Foundation

public enum SignRequestSignerInputNumberWithCommaValidationValidationTypeField: CodableStringEnum {
    case numberWithComma
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "number_with_comma".lowercased():
            self = .numberWithComma
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .numberWithComma:
            return "number_with_comma"
        case .customValue(let value):
            return value
        }
    }

}
