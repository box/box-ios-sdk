import Foundation

public enum HubCalloutBoxTextBlockV2025R0TypeField: CodableStringEnum {
    case calloutBox
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "callout_box".lowercased():
            self = .calloutBox
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .calloutBox:
            return "callout_box"
        case .customValue(let value):
            return value
        }
    }

}
