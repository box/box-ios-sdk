import Foundation

public enum MetadataFilterScopeField: CodableStringEnum {
    case global
    case enterprise
    case enterpriseEnterpriseId
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "global".lowercased():
            self = .global
        case "enterprise".lowercased():
            self = .enterprise
        case "enterprise_{enterprise_id}".lowercased():
            self = .enterpriseEnterpriseId
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .global:
            return "global"
        case .enterprise:
            return "enterprise"
        case .enterpriseEnterpriseId:
            return "enterprise_{enterprise_id}"
        case .customValue(let value):
            return value
        }
    }

}
