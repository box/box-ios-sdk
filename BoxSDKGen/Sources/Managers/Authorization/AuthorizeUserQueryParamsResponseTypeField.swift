import Foundation

public enum AuthorizeUserQueryParamsResponseTypeField: CodableStringEnum {
    case code
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "code".lowercased():
            self = .code
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .code:
            return "code"
        case .customValue(let value):
            return value
        }
    }

}
