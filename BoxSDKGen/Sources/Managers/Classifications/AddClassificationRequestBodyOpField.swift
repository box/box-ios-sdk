import Foundation

public enum AddClassificationRequestBodyOpField: CodableStringEnum {
    case addEnumOption
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "addEnumOption".lowercased():
            self = .addEnumOption
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .addEnumOption:
            return "addEnumOption"
        case .customValue(let value):
            return value
        }
    }

}
