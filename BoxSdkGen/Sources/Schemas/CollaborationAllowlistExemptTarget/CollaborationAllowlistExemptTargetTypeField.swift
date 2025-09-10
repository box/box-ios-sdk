import Foundation

public enum CollaborationAllowlistExemptTargetTypeField: CodableStringEnum {
    case collaborationWhitelistExemptTarget
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "collaboration_whitelist_exempt_target".lowercased():
            self = .collaborationWhitelistExemptTarget
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .collaborationWhitelistExemptTarget:
            return "collaboration_whitelist_exempt_target"
        case .customValue(let value):
            return value
        }
    }

}
