import Foundation

public enum ShuttlePathEntrySharedSpaceScopeV2026R0TypeField: CodableStringEnum {
    case sharedSpace
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shared_space".lowercased():
            self = .sharedSpace
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .sharedSpace:
            return "shared_space"
        case .customValue(let value):
            return value
        }
    }

}
