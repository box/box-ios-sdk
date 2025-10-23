import Foundation

/// The collaboration restriction.
public enum CollaborationRestrictionV2025R0: CodableStringEnum {
    case internal_
    case external
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "internal".lowercased():
            self = .internal_
        case "external".lowercased():
            self = .external
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .internal_:
            return "internal"
        case .external:
            return "external"
        case .customValue(let value):
            return value
        }
    }

}
