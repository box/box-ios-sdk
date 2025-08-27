import Foundation

public enum CollaborationTypeField: CodableStringEnum {
    case collaboration
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "collaboration".lowercased():
            self = .collaboration
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .collaboration:
            return "collaboration"
        case .customValue(let value):
            return value
        }
    }

}
