import Foundation

public enum SearchForContentQueryParamsContentTypesField: CodableStringEnum {
    case name
    case description
    case fileContent
    case comments
    case tags
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "name".lowercased():
            self = .name
        case "description".lowercased():
            self = .description
        case "file_content".lowercased():
            self = .fileContent
        case "comments".lowercased():
            self = .comments
        case "tags".lowercased():
            self = .tags
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .name:
            return "name"
        case .description:
            return "description"
        case .fileContent:
            return "file_content"
        case .comments:
            return "comments"
        case .tags:
            return "tags"
        case .customValue(let value):
            return value
        }
    }

}
