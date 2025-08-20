import Foundation

public enum MetadataCascadePolicyTypeField: CodableStringEnum {
    case metadataCascadePolicy
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "metadata_cascade_policy".lowercased():
            self = .metadataCascadePolicy
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .metadataCascadePolicy:
            return "metadata_cascade_policy"
        case .customValue(let value):
            return value
        }
    }

}
