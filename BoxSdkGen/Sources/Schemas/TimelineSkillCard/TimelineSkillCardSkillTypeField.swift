import Foundation

public enum TimelineSkillCardSkillTypeField: CodableStringEnum {
    case service
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "service".lowercased():
            self = .service
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .service:
            return "service"
        case .customValue(let value):
            return value
        }
    }

}
