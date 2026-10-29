import Foundation

public enum ShuttlePathEntryV2026R0TypeField: CodableStringEnum {
    case shuttlePathEntry
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_path_entry".lowercased():
            self = .shuttlePathEntry
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttlePathEntry:
            return "shuttle_path_entry"
        case .customValue(let value):
            return value
        }
    }

}
