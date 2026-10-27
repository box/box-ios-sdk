import Foundation

public enum ShuttleRunV2026R0TypeField: CodableStringEnum {
    case shuttleRun
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_run".lowercased():
            self = .shuttleRun
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttleRun:
            return "shuttle_run"
        case .customValue(let value):
            return value
        }
    }

}
