import Foundation

public enum CompletionRuleVariableTypeField: CodableStringEnum {
    case variable
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "variable".lowercased():
            self = .variable
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .variable:
            return "variable"
        case .customValue(let value):
            return value
        }
    }

}
