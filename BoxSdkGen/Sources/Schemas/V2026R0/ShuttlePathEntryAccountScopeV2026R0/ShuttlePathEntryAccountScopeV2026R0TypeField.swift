import Foundation

public enum ShuttlePathEntryAccountScopeV2026R0TypeField: CodableStringEnum {
    case account
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "account".lowercased():
            self = .account
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .account:
            return "account"
        case .customValue(let value):
            return value
        }
    }

}
