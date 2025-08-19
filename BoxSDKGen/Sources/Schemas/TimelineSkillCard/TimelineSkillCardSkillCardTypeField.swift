import Foundation

public enum TimelineSkillCardSkillCardTypeField: CodableStringEnum {
    case timeline
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "timeline".lowercased():
            self = .timeline
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .timeline:
            return "timeline"
        case .customValue(let value):
            return value
        }
    }

}
