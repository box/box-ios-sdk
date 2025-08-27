import Foundation

public enum CollaborationAllowlistEntryDirectionField: CodableStringEnum {
    case inbound
    case outbound
    case both
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "inbound".lowercased():
            self = .inbound
        case "outbound".lowercased():
            self = .outbound
        case "both".lowercased():
            self = .both
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .inbound:
            return "inbound"
        case .outbound:
            return "outbound"
        case .both:
            return "both"
        case .customValue(let value):
            return value
        }
    }

}
