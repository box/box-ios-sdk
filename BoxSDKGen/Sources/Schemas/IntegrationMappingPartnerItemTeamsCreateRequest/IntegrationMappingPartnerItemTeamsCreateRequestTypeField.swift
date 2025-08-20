import Foundation

public enum IntegrationMappingPartnerItemTeamsCreateRequestTypeField: CodableStringEnum {
    case channel
    case team
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "channel".lowercased():
            self = .channel
        case "team".lowercased():
            self = .team
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .channel:
            return "channel"
        case .team:
            return "team"
        case .customValue(let value):
            return value
        }
    }

}
