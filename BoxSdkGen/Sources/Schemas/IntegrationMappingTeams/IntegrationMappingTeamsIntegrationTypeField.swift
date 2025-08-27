import Foundation

public enum IntegrationMappingTeamsIntegrationTypeField: CodableStringEnum {
    case teams
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "teams".lowercased():
            self = .teams
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .teams:
            return "teams"
        case .customValue(let value):
            return value
        }
    }

}
