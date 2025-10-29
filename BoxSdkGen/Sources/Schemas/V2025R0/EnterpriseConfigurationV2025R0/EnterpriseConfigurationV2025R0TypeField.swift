import Foundation

public enum EnterpriseConfigurationV2025R0TypeField: CodableStringEnum {
    case enterpriseConfiguration
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "enterprise_configuration".lowercased():
            self = .enterpriseConfiguration
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .enterpriseConfiguration:
            return "enterprise_configuration"
        case .customValue(let value):
            return value
        }
    }

}
