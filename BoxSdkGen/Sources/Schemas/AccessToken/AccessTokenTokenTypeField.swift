import Foundation

public enum AccessTokenTokenTypeField: CodableStringEnum {
    case bearer
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "bearer".lowercased():
            self = .bearer
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .bearer:
            return "bearer"
        case .customValue(let value):
            return value
        }
    }

}
