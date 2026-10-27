import Foundation

public enum GetShuttlePathEntriesV2026R0QueryParamsSideField: CodableStringEnum {
    case source
    case target
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "source".lowercased():
            self = .source
        case "target".lowercased():
            self = .target
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .source:
            return "source"
        case .target:
            return "target"
        case .customValue(let value):
            return value
        }
    }

}
