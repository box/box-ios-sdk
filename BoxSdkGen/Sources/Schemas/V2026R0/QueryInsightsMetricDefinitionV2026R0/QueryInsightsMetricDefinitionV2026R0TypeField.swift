import Foundation

public enum QueryInsightsMetricDefinitionV2026R0TypeField: CodableStringEnum {
    case sum
    case avg
    case min
    case max
    case count
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "sum".lowercased():
            self = .sum
        case "avg".lowercased():
            self = .avg
        case "min".lowercased():
            self = .min
        case "max".lowercased():
            self = .max
        case "count".lowercased():
            self = .count
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .sum:
            return "sum"
        case .avg:
            return "avg"
        case .min:
            return "min"
        case .max:
            return "max"
        case .count:
            return "count"
        case .customValue(let value):
            return value
        }
    }

}
