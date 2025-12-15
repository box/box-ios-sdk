import Foundation

public enum CreateMetadataTemplateRequestBodyFieldsTypeField: CodableStringEnum {
    case string
    case float
    case date
    case enum_
    case multiSelect
    case taxonomy
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "string".lowercased():
            self = .string
        case "float".lowercased():
            self = .float
        case "date".lowercased():
            self = .date
        case "enum".lowercased():
            self = .enum_
        case "multiSelect".lowercased():
            self = .multiSelect
        case "taxonomy".lowercased():
            self = .taxonomy
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .string:
            return "string"
        case .float:
            return "float"
        case .date:
            return "date"
        case .enum_:
            return "enum"
        case .multiSelect:
            return "multiSelect"
        case .taxonomy:
            return "taxonomy"
        case .customValue(let value):
            return value
        }
    }

}
