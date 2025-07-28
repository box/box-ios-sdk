import Foundation

public enum DevicePinnersOrderByField: CodableStringEnum {
    case id
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "id".lowercased():
            self = .id
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .id:
            return "id"
        case .customValue(let value):
            return value
        }
    }

}
