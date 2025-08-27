import Foundation

public enum ClientErrorV2025R0TypeField: CodableStringEnum {
    case error
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "error".lowercased():
            self = .error
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .error:
            return "error"
        case .customValue(let value):
            return value
        }
    }

}
