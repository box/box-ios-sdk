import Foundation

public enum SignTemplateTypeField: CodableStringEnum {
    case signTemplate
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "sign-template".lowercased():
            self = .signTemplate
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .signTemplate:
            return "sign-template"
        case .customValue(let value):
            return value
        }
    }

}
