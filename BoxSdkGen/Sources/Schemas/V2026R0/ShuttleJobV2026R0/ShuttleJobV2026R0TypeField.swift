import Foundation

public enum ShuttleJobV2026R0TypeField: CodableStringEnum {
    case shuttleJob
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_job".lowercased():
            self = .shuttleJob
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttleJob:
            return "shuttle_job"
        case .customValue(let value):
            return value
        }
    }

}
