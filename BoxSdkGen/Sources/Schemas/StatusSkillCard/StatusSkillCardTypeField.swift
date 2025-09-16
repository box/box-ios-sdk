import Foundation

public enum StatusSkillCardTypeField: CodableStringEnum {
    case skillCard
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "skill_card".lowercased():
            self = .skillCard
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .skillCard:
            return "skill_card"
        case .customValue(let value):
            return value
        }
    }

}
