import Foundation

public enum SignRequestSignerInputZip4ValidationValidationTypeField: CodableStringEnum {
    case zip4
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "zip_4".lowercased():
            self = .zip4
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .zip4:
            return "zip_4"
        case .customValue(let value):
            return value
        }
    }

}
