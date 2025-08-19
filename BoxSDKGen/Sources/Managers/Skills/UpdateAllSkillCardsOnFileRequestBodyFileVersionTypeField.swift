import Foundation

public enum UpdateAllSkillCardsOnFileRequestBodyFileVersionTypeField: CodableStringEnum {
    case fileVersion
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "file_version".lowercased():
            self = .fileVersion
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .fileVersion:
            return "file_version"
        case .customValue(let value):
            return value
        }
    }

}
