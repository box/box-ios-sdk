import Foundation

public enum MetadataQueryIndexStatusField: CodableStringEnum {
    case building
    case active
    case disabled
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "building".lowercased():
            self = .building
        case "active".lowercased():
            self = .active
        case "disabled".lowercased():
            self = .disabled
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .building:
            return "building"
        case .active:
            return "active"
        case .disabled:
            return "disabled"
        case .customValue(let value):
            return value
        }
    }

}
