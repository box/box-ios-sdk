import Foundation

public enum DocumentSplitCreateRequestV2026R0InputSourceField: CodableStringEnum {
    case api
    case box
    case relay
    case salesforce
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "api".lowercased():
            self = .api
        case "box".lowercased():
            self = .box
        case "relay".lowercased():
            self = .relay
        case "salesforce".lowercased():
            self = .salesforce
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .api:
            return "api"
        case .box:
            return "box"
        case .relay:
            return "relay"
        case .salesforce:
            return "salesforce"
        case .customValue(let value):
            return value
        }
    }

}
