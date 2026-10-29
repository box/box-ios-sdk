import Foundation

public enum ShuttleReportV2026R0TypeField: CodableStringEnum {
    case shuttleReport
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_report".lowercased():
            self = .shuttleReport
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttleReport:
            return "shuttle_report"
        case .customValue(let value):
            return value
        }
    }

}
