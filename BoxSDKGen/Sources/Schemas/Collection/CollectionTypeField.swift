import Foundation

public enum CollectionTypeField: CodableStringEnum {
    case collection
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "collection".lowercased():
            self = .collection
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .collection:
            return "collection"
        case .customValue(let value):
            return value
        }
    }

}
