import Foundation

public enum ShuttleSystemV2026R0TypeField: CodableStringEnum {
    case shuttleSystem
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_system".lowercased():
            self = .shuttleSystem
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttleSystem:
            return "shuttle_system"
        case .customValue(let value):
            return value
        }
    }

}
