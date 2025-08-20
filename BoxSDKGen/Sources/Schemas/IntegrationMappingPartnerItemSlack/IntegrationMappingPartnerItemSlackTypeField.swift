import Foundation

public enum IntegrationMappingPartnerItemSlackTypeField: CodableStringEnum {
    case channel
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "channel".lowercased():
            self = .channel
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .channel:
            return "channel"
        case .customValue(let value):
            return value
        }
    }

}
