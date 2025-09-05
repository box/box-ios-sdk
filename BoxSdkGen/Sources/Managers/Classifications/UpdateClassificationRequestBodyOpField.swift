import Foundation

public enum UpdateClassificationRequestBodyOpField: CodableStringEnum {
    case editEnumOption
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "editEnumOption".lowercased():
            self = .editEnumOption
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .editEnumOption:
            return "editEnumOption"
        case .customValue(let value):
            return value
        }
    }

}
