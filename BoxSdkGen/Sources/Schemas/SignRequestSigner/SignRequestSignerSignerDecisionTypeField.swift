import Foundation

public enum SignRequestSignerSignerDecisionTypeField: CodableStringEnum {
    case signed
    case declined
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "signed".lowercased():
            self = .signed
        case "declined".lowercased():
            self = .declined
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .signed:
            return "signed"
        case .declined:
            return "declined"
        case .customValue(let value):
            return value
        }
    }

}
