import Foundation

public enum ApplyMetadataCascadePolicyRequestBodyConflictResolutionField: CodableStringEnum {
    case none
    case overwrite
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "none".lowercased():
            self = .none
        case "overwrite".lowercased():
            self = .overwrite
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .none:
            return "none"
        case .overwrite:
            return "overwrite"
        case .customValue(let value):
            return value
        }
    }

}
