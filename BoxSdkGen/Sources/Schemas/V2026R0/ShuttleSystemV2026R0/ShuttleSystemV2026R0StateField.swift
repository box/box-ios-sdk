import Foundation

public enum ShuttleSystemV2026R0StateField: CodableStringEnum {
    case connected
    case disconnected
    case unknown
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "connected".lowercased():
            self = .connected
        case "disconnected".lowercased():
            self = .disconnected
        case "unknown".lowercased():
            self = .unknown
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .connected:
            return "connected"
        case .disconnected:
            return "disconnected"
        case .unknown:
            return "unknown"
        case .customValue(let value):
            return value
        }
    }

}
