import Foundation

public enum ShuttleJobScheduleTriggerByJobV2026R0TypeField: CodableStringEnum {
    case byJob
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "by_job".lowercased():
            self = .byJob
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .byJob:
            return "by_job"
        case .customValue(let value):
            return value
        }
    }

}
