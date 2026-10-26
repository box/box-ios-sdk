import Foundation

public enum ShuttleSystemCreateRequestV2026R0SystemTypeField: CodableStringEnum {
    case windows
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "windows".lowercased():
            self = .windows
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .windows:
            return "windows"
        case .customValue(let value):
            return value
        }
    }

}
