import Foundation

public enum TranscriptSkillCardInvocationTypeField: CodableStringEnum {
    case skillInvocation
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "skill_invocation".lowercased():
            self = .skillInvocation
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .skillInvocation:
            return "skill_invocation"
        case .customValue(let value):
            return value
        }
    }

}
