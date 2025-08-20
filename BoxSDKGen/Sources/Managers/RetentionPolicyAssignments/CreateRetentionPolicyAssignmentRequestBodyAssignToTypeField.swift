import Foundation

public enum CreateRetentionPolicyAssignmentRequestBodyAssignToTypeField: CodableStringEnum {
    case enterprise
    case folder
    case metadataTemplate
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "enterprise".lowercased():
            self = .enterprise
        case "folder".lowercased():
            self = .folder
        case "metadata_template".lowercased():
            self = .metadataTemplate
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .enterprise:
            return "enterprise"
        case .folder:
            return "folder"
        case .metadataTemplate:
            return "metadata_template"
        case .customValue(let value):
            return value
        }
    }

}
