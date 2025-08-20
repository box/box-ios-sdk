import Foundation

public enum EnterpriseReferenceV2025R0TypeField: CodableStringEnum {
    case enterprise
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "enterprise".lowercased():
            self = .enterprise
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .enterprise:
            return "enterprise"
        case .customValue(let value):
            return value
        }
    }

}
