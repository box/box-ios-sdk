import Foundation

public enum DocumentSplitCreateRequestPageSelectionV2026R0VersionField: CodableStringEnum {
    case v2
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "v_2".lowercased():
            self = .v2
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .v2:
            return "v_2"
        case .customValue(let value):
            return value
        }
    }

}
