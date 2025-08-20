import Foundation

public enum CreateClassificationTemplateRequestBodyTemplateKeyField: CodableStringEnum {
    case securityClassification6VmVochwUWo
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "securityClassification-6VMVochwUWo".lowercased():
            self = .securityClassification6VmVochwUWo
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .securityClassification6VmVochwUWo:
            return "securityClassification-6VMVochwUWo"
        case .customValue(let value):
            return value
        }
    }

}
