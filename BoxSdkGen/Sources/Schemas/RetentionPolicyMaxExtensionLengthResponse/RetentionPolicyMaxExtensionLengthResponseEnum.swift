import Foundation

public enum RetentionPolicyMaxExtensionLengthResponseEnum: CodableStringEnum {
    case none
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "none".lowercased():
            self = .none
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .none:
            return "none"
        case .customValue(let value):
            return value
        }
    }

}
