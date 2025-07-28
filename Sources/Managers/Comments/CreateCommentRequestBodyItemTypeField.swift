import Foundation

public enum CreateCommentRequestBodyItemTypeField: CodableStringEnum {
    case file
    case comment
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "file".lowercased():
            self = .file
        case "comment".lowercased():
            self = .comment
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .file:
            return "file"
        case .comment:
            return "comment"
        case .customValue(let value):
            return value
        }
    }

}
