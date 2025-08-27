import Foundation

public enum StatusSkillCardSkillCardTypeField: CodableStringEnum {
    case status
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "status".lowercased():
            self = .status
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .status:
            return "status"
        case .customValue(let value):
            return value
        }
    }

}
