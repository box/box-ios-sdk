import Foundation

public enum SignRequestSignerInputNumberWithPeriodValidationValidationTypeField: CodableStringEnum {
    case numberWithPeriod
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "number_with_period".lowercased():
            self = .numberWithPeriod
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .numberWithPeriod:
            return "number_with_period"
        case .customValue(let value):
            return value
        }
    }

}
