import Foundation

public enum CollectionCollectionTypeField: CodableStringEnum {
    case favorites
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "favorites".lowercased():
            self = .favorites
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .favorites:
            return "favorites"
        case .customValue(let value):
            return value
        }
    }

}
