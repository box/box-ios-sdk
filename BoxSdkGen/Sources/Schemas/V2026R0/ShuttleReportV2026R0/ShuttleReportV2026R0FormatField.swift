import Foundation

public enum ShuttleReportV2026R0FormatField: CodableStringEnum {
    case xlsx
    case csv
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "xlsx".lowercased():
            self = .xlsx
        case "csv".lowercased():
            self = .csv
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .xlsx:
            return "xlsx"
        case .csv:
            return "csv"
        case .customValue(let value):
            return value
        }
    }

}
