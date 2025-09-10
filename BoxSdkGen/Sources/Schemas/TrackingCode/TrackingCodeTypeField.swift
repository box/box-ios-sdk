import Foundation

public enum TrackingCodeTypeField: CodableStringEnum {
    case trackingCode
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "tracking_code".lowercased():
            self = .trackingCode
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .trackingCode:
            return "tracking_code"
        case .customValue(let value):
            return value
        }
    }

}
