import Foundation

/// The strategy used to resolve permission conflicts.
public enum ShuttleJobPermissionConflictStrategyV2026R0: CodableStringEnum {
    case preserveStructureRestrictSharing
    case preserveStructureExpandSharing
    case preserveSharingModifyStructure
    case warnPermissionsConflicts
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "preserve_structure_restrict_sharing".lowercased():
            self = .preserveStructureRestrictSharing
        case "preserve_structure_expand_sharing".lowercased():
            self = .preserveStructureExpandSharing
        case "preserve_sharing_modify_structure".lowercased():
            self = .preserveSharingModifyStructure
        case "warn_permissions_conflicts".lowercased():
            self = .warnPermissionsConflicts
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .preserveStructureRestrictSharing:
            return "preserve_structure_restrict_sharing"
        case .preserveStructureExpandSharing:
            return "preserve_structure_expand_sharing"
        case .preserveSharingModifyStructure:
            return "preserve_sharing_modify_structure"
        case .warnPermissionsConflicts:
            return "warn_permissions_conflicts"
        case .customValue(let value):
            return value
        }
    }

}
