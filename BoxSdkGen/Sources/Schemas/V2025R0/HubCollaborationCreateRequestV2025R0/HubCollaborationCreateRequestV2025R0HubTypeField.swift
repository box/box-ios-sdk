import Foundation

public enum HubCollaborationCreateRequestV2025R0HubTypeField: CodableStringEnum {
    case hubs
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "hubs".lowercased():
            self = .hubs
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .hubs:
            return "hubs"
        case .customValue(let value):
            return value
        }
    }

}
