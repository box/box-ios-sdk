import Foundation

public enum GetRetentionPolicyAssignmentsQueryParamsTypeField: CodableStringEnum {
    case folder
    case enterprise
    case metadataTemplate
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "folder".lowercased():
            self = .folder
        case "enterprise".lowercased():
            self = .enterprise
        case "metadata_template".lowercased():
            self = .metadataTemplate
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .folder:
            return "folder"
        case .enterprise:
            return "enterprise"
        case .metadataTemplate:
            return "metadata_template"
        case .customValue(let value):
            return value
        }
    }

}
