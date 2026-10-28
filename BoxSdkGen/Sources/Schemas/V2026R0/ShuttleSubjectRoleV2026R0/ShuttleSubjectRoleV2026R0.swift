import Foundation

/// A role a source subject holds on the source system.
public enum ShuttleSubjectRoleV2026R0: CodableStringEnum {
    case owner
    case creator
    case updater
    case namespaceAccount
    case sharee
    case accountHolder
    case unknown
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "owner".lowercased():
            self = .owner
        case "creator".lowercased():
            self = .creator
        case "updater".lowercased():
            self = .updater
        case "namespace_account".lowercased():
            self = .namespaceAccount
        case "sharee".lowercased():
            self = .sharee
        case "account_holder".lowercased():
            self = .accountHolder
        case "unknown".lowercased():
            self = .unknown
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .owner:
            return "owner"
        case .creator:
            return "creator"
        case .updater:
            return "updater"
        case .namespaceAccount:
            return "namespace_account"
        case .sharee:
            return "sharee"
        case .accountHolder:
            return "account_holder"
        case .unknown:
            return "unknown"
        case .customValue(let value):
            return value
        }
    }

}
