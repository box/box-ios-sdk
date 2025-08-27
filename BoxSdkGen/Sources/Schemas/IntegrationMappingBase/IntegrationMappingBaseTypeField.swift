import Foundation

public enum IntegrationMappingBaseTypeField: CodableStringEnum {
    case integrationMapping
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "integration_mapping".lowercased():
            self = .integrationMapping
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .integrationMapping:
            return "integration_mapping"
        case .customValue(let value):
            return value
        }
    }

}
