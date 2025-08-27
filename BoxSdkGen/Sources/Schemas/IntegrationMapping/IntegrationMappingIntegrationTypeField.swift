import Foundation

public enum IntegrationMappingIntegrationTypeField: CodableStringEnum {
    case slack
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "slack".lowercased():
            self = .slack
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .slack:
            return "slack"
        case .customValue(let value):
            return value
        }
    }

}
