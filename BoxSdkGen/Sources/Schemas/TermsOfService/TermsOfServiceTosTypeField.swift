import Foundation

public enum TermsOfServiceTosTypeField: CodableStringEnum {
    case managed
    case external
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "managed".lowercased():
            self = .managed
        case "external".lowercased():
            self = .external
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .managed:
            return "managed"
        case .external:
            return "external"
        case .customValue(let value):
            return value
        }
    }

}
