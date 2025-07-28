import Foundation

public enum CreateClassificationTemplateRequestBodyFieldsKeyField: CodableStringEnum {
    case boxSecurityClassificationKey
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "Box__Security__Classification__Key".lowercased():
            self = .boxSecurityClassificationKey
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .boxSecurityClassificationKey:
            return "Box__Security__Classification__Key"
        case .customValue(let value):
            return value
        }
    }

}
