import Foundation

public enum SignTemplateAdditionalInfoNonEditableField: CodableStringEnum {
    case emailSubject
    case emailMessage
    case name
    case daysValid
    case signers
    case sourceFiles
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "email_subject".lowercased():
            self = .emailSubject
        case "email_message".lowercased():
            self = .emailMessage
        case "name".lowercased():
            self = .name
        case "days_valid".lowercased():
            self = .daysValid
        case "signers".lowercased():
            self = .signers
        case "source_files".lowercased():
            self = .sourceFiles
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .emailSubject:
            return "email_subject"
        case .emailMessage:
            return "email_message"
        case .name:
            return "name"
        case .daysValid:
            return "days_valid"
        case .signers:
            return "signers"
        case .sourceFiles:
            return "source_files"
        case .customValue(let value):
            return value
        }
    }

}
