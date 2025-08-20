import Foundation

public enum KeywordSkillCardSkillCardTypeField: CodableStringEnum {
    case keyword
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "keyword".lowercased():
            self = .keyword
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .keyword:
            return "keyword"
        case .customValue(let value):
            return value
        }
    }

}
