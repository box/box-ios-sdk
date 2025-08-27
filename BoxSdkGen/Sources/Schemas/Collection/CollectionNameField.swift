import Foundation

public enum CollectionNameField: CodableStringEnum {
    case favorites
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "Favorites".lowercased():
            self = .favorites
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .favorites:
            return "Favorites"
        case .customValue(let value):
            return value
        }
    }

}
