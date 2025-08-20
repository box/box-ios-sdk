import Foundation

public enum UpdateShieldInformationBarrierStatusRequestBodyStatusField: CodableStringEnum {
    case pending
    case disabled
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "pending".lowercased():
            self = .pending
        case "disabled".lowercased():
            self = .disabled
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .pending:
            return "pending"
        case .disabled:
            return "disabled"
        case .customValue(let value):
            return value
        }
    }

}
