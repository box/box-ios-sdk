import Foundation

public enum SignRequestTypeField: CodableStringEnum {
    case signRequest
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "sign-request".lowercased():
            self = .signRequest
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .signRequest:
            return "sign-request"
        case .customValue(let value):
            return value
        }
    }

}
