import Foundation

public enum SignRequestSignerInputZipValidationValidationTypeField: CodableStringEnum {
    case zip
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "zip".lowercased():
            self = .zip
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .zip:
            return "zip"
        case .customValue(let value):
            return value
        }
    }

}
