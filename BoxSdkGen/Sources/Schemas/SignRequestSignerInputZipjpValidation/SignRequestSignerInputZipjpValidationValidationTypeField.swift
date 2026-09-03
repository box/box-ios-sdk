import Foundation

public enum SignRequestSignerInputZipjpValidationValidationTypeField: CodableStringEnum {
    case zipJp
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "zip_jp".lowercased():
            self = .zipJp
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .zipJp:
            return "zip_jp"
        case .customValue(let value):
            return value
        }
    }

}
