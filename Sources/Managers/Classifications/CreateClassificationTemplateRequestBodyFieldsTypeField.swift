import Foundation

public enum CreateClassificationTemplateRequestBodyFieldsTypeField: CodableStringEnum {
    case enum_
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "enum".lowercased():
            self = .enum_
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .enum_:
            return "enum"
        case .customValue(let value):
            return value
        }
    }

}
