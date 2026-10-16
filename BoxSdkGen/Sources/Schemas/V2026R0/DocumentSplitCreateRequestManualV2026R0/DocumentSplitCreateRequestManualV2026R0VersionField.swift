import Foundation

public enum DocumentSplitCreateRequestManualV2026R0VersionField: CodableStringEnum {
    case v1
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "v_1".lowercased():
            self = .v1
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .v1:
            return "v_1"
        case .customValue(let value):
            return value
        }
    }

}
