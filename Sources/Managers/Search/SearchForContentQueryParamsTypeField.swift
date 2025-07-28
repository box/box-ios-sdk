import Foundation

public enum SearchForContentQueryParamsTypeField: CodableStringEnum {
    case file
    case folder
    case webLink
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "file".lowercased():
            self = .file
        case "folder".lowercased():
            self = .folder
        case "web_link".lowercased():
            self = .webLink
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .file:
            return "file"
        case .folder:
            return "folder"
        case .webLink:
            return "web_link"
        case .customValue(let value):
            return value
        }
    }

}
