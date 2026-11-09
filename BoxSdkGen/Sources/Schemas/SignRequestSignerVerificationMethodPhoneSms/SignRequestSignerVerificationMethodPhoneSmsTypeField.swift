import Foundation

public enum SignRequestSignerVerificationMethodPhoneSmsTypeField: CodableStringEnum {
    case phone
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "phone".lowercased():
            self = .phone
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .phone:
            return "phone"
        case .customValue(let value):
            return value
        }
    }

}
