import Foundation

public enum SignRequestCreateRequestSignatureColorField: CodableStringEnum {
    case blue
    case black
    case red
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "blue".lowercased():
            self = .blue
        case "black".lowercased():
            self = .black
        case "red".lowercased():
            self = .red
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .blue:
            return "blue"
        case .black:
            return "black"
        case .red:
            return "red"
        case .customValue(let value):
            return value
        }
    }

}
