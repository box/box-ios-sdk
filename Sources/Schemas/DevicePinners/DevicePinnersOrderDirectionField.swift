import Foundation

public enum DevicePinnersOrderDirectionField: CodableStringEnum {
    case asc
    case desc
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "asc".lowercased():
            self = .asc
        case "desc".lowercased():
            self = .desc
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .asc:
            return "asc"
        case .desc:
            return "desc"
        case .customValue(let value):
            return value
        }
    }

}
