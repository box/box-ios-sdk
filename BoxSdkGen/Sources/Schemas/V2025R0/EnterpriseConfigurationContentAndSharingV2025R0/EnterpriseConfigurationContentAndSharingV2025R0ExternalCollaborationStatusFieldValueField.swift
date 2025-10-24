import Foundation

public enum EnterpriseConfigurationContentAndSharingV2025R0ExternalCollaborationStatusFieldValueField: CodableStringEnum {
    case enableExternalCollaboration
    case limitCollaborationToAllowlistedDomains
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "enable_external_collaboration".lowercased():
            self = .enableExternalCollaboration
        case "limit_collaboration_to_allowlisted_domains".lowercased():
            self = .limitCollaborationToAllowlistedDomains
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .enableExternalCollaboration:
            return "enable_external_collaboration"
        case .limitCollaborationToAllowlistedDomains:
            return "limit_collaboration_to_allowlisted_domains"
        case .customValue(let value):
            return value
        }
    }

}
