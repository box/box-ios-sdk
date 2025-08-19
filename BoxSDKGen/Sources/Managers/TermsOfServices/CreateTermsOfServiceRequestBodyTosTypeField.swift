import Foundation

public enum CreateTermsOfServiceRequestBodyTosTypeField: CodableStringEnum {
    case external
    case managed
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "external".lowercased():
            self = .external
        case "managed".lowercased():
            self = .managed
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .external:
            return "external"
        case .managed:
            return "managed"
        case .customValue(let value):
            return value
        }
    }

}
