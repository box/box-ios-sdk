import Foundation

public enum SignRequestSignerInputDateAsiaValidationValidationTypeField: CodableStringEnum {
    case dateAsia
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "date_asia".lowercased():
            self = .dateAsia
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .dateAsia:
            return "date_asia"
        case .customValue(let value):
            return value
        }
    }

}
