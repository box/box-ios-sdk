import Foundation

public enum SkillInvocationSkillTypeField: CodableStringEnum {
    case skill
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "skill".lowercased():
            self = .skill
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .skill:
            return "skill"
        case .customValue(let value):
            return value
        }
    }

}
