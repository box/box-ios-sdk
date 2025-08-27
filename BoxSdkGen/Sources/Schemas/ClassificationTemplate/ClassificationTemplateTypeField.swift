import Foundation

public enum ClassificationTemplateTypeField: CodableStringEnum {
    case metadataTemplate
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "metadata_template".lowercased():
            self = .metadataTemplate
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .metadataTemplate:
            return "metadata_template"
        case .customValue(let value):
            return value
        }
    }

}
