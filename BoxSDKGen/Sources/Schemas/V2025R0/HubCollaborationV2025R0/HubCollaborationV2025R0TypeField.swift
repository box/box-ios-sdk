import Foundation

public enum HubCollaborationV2025R0TypeField: CodableStringEnum {
    case hubCollaboration
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "hub_collaboration".lowercased():
            self = .hubCollaboration
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .hubCollaboration:
            return "hub_collaboration"
        case .customValue(let value):
            return value
        }
    }

}
