import Foundation

public enum TemplateSignerInputTypeField: CodableStringEnum {
    case signature
    case date
    case text
    case checkbox
    case attachment
    case radio
    case dropdown
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "signature".lowercased():
            self = .signature
        case "date".lowercased():
            self = .date
        case "text".lowercased():
            self = .text
        case "checkbox".lowercased():
            self = .checkbox
        case "attachment".lowercased():
            self = .attachment
        case "radio".lowercased():
            self = .radio
        case "dropdown".lowercased():
            self = .dropdown
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .signature:
            return "signature"
        case .date:
            return "date"
        case .text:
            return "text"
        case .checkbox:
            return "checkbox"
        case .attachment:
            return "attachment"
        case .radio:
            return "radio"
        case .dropdown:
            return "dropdown"
        case .customValue(let value):
            return value
        }
    }

}
