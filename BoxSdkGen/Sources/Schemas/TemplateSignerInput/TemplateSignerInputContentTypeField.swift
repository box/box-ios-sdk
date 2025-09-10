import Foundation

public enum TemplateSignerInputContentTypeField: CodableStringEnum {
    case signature
    case initial
    case stamp
    case date
    case checkbox
    case text
    case fullName
    case firstName
    case lastName
    case company
    case title
    case email
    case attachment
    case radio
    case dropdown
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "signature".lowercased():
            self = .signature
        case "initial".lowercased():
            self = .initial
        case "stamp".lowercased():
            self = .stamp
        case "date".lowercased():
            self = .date
        case "checkbox".lowercased():
            self = .checkbox
        case "text".lowercased():
            self = .text
        case "full_name".lowercased():
            self = .fullName
        case "first_name".lowercased():
            self = .firstName
        case "last_name".lowercased():
            self = .lastName
        case "company".lowercased():
            self = .company
        case "title".lowercased():
            self = .title
        case "email".lowercased():
            self = .email
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
        case .initial:
            return "initial"
        case .stamp:
            return "stamp"
        case .date:
            return "date"
        case .checkbox:
            return "checkbox"
        case .text:
            return "text"
        case .fullName:
            return "full_name"
        case .firstName:
            return "first_name"
        case .lastName:
            return "last_name"
        case .company:
            return "company"
        case .title:
            return "title"
        case .email:
            return "email"
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
