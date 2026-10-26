import Foundation

public enum ShuttleJobScheduleV2026R0TypeField: CodableStringEnum {
    case shuttleJobSchedule
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_job_schedule".lowercased():
            self = .shuttleJobSchedule
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttleJobSchedule:
            return "shuttle_job_schedule"
        case .customValue(let value):
            return value
        }
    }

}
