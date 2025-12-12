import Foundation

public enum SignRequestSignerInputDateUsValidationValidationTypeField: CodableStringEnum {
    case dateUs
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "date_us".lowercased():
            self = .dateUs
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .dateUs:
            return "date_us"
        case .customValue(let value):
            return value
        }
    }

}
