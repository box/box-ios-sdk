import Foundation

public enum CollaborationAllowlistEntryTypeField: CodableStringEnum {
    case collaborationWhitelistEntry
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "collaboration_whitelist_entry".lowercased():
            self = .collaborationWhitelistEntry
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .collaborationWhitelistEntry:
            return "collaboration_whitelist_entry"
        case .customValue(let value):
            return value
        }
    }

}
