import Foundation

public enum TranscriptSkillCardSkillCardTypeField: CodableStringEnum {
    case transcript
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "transcript".lowercased():
            self = .transcript
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .transcript:
            return "transcript"
        case .customValue(let value):
            return value
        }
    }

}
