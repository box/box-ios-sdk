import Foundation

public enum UpdateFolderMetadataByIdRequestBodyOpField: CodableStringEnum {
    case add
    case replace
    case remove
    case test
    case move
    case copy
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "add".lowercased():
            self = .add
        case "replace".lowercased():
            self = .replace
        case "remove".lowercased():
            self = .remove
        case "test".lowercased():
            self = .test
        case "move".lowercased():
            self = .move
        case "copy".lowercased():
            self = .copy
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .add:
            return "add"
        case .replace:
            return "replace"
        case .remove:
            return "remove"
        case .test:
            return "test"
        case .move:
            return "move"
        case .copy:
            return "copy"
        case .customValue(let value):
            return value
        }
    }

}
