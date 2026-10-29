import Foundation

public enum DocumentSplitCreateRequestManualV2026R0SplitTypeField: CodableStringEnum {
    case manual
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "manual".lowercased():
            self = .manual
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .manual:
            return "manual"
        case .customValue(let value):
            return value
        }
    }

}
