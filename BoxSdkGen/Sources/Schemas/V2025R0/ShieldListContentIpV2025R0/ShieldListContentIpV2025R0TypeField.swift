import Foundation

public enum ShieldListContentIpV2025R0TypeField: CodableStringEnum {
    case ip
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ip".lowercased():
            self = .ip
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .ip:
            return "ip"
        case .customValue(let value):
            return value
        }
    }

}
