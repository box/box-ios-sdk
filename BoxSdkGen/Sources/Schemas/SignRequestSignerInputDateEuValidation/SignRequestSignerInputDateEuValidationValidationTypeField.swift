import Foundation

public enum SignRequestSignerInputDateEuValidationValidationTypeField: CodableStringEnum {
    case dateEu
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "date_eu".lowercased():
            self = .dateEu
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .dateEu:
            return "date_eu"
        case .customValue(let value):
            return value
        }
    }

}
