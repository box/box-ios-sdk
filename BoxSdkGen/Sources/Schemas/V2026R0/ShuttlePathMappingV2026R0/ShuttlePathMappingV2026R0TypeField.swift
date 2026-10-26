import Foundation

public enum ShuttlePathMappingV2026R0TypeField: CodableStringEnum {
    case shuttlePathMapping
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_path_mapping".lowercased():
            self = .shuttlePathMapping
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttlePathMapping:
            return "shuttle_path_mapping"
        case .customValue(let value):
            return value
        }
    }

}
