import Foundation

public enum ShieldListContentIntegrationV2025R0TypeField: CodableStringEnum {
    case integration
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "integration".lowercased():
            self = .integration
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .integration:
            return "integration"
        case .customValue(let value):
            return value
        }
    }

}
