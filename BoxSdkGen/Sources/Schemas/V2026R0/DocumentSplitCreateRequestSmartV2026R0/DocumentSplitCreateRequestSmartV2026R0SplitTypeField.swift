import Foundation

public enum DocumentSplitCreateRequestSmartV2026R0SplitTypeField: CodableStringEnum {
    case smart
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "smart".lowercased():
            self = .smart
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .smart:
            return "smart"
        case .customValue(let value):
            return value
        }
    }

}
