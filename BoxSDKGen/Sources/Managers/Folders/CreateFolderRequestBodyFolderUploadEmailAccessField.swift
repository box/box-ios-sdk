import Foundation

public enum CreateFolderRequestBodyFolderUploadEmailAccessField: CodableStringEnum {
    case open
    case collaborators
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "open".lowercased():
            self = .open
        case "collaborators".lowercased():
            self = .collaborators
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .open:
            return "open"
        case .collaborators:
            return "collaborators"
        case .customValue(let value):
            return value
        }
    }

}
