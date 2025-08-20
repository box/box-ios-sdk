import Foundation

public enum CommentBaseTypeField: CodableStringEnum {
    case comment
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "comment".lowercased():
            self = .comment
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .comment:
            return "comment"
        case .customValue(let value):
            return value
        }
    }

}
