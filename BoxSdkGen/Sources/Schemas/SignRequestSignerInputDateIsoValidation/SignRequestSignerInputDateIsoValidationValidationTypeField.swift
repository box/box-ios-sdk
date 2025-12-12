import Foundation

public enum SignRequestSignerInputDateIsoValidationValidationTypeField: CodableStringEnum {
    case dateIso
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "date_iso".lowercased():
            self = .dateIso
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .dateIso:
            return "date_iso"
        case .customValue(let value):
            return value
        }
    }

}
