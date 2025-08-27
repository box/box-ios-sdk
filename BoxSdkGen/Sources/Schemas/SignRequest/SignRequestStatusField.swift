import Foundation

public enum SignRequestStatusField: CodableStringEnum {
    case converting
    case created
    case sent
    case viewed
    case signed
    case cancelled
    case declined
    case errorConverting
    case errorSending
    case expired
    case finalizing
    case errorFinalizing
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "converting".lowercased():
            self = .converting
        case "created".lowercased():
            self = .created
        case "sent".lowercased():
            self = .sent
        case "viewed".lowercased():
            self = .viewed
        case "signed".lowercased():
            self = .signed
        case "cancelled".lowercased():
            self = .cancelled
        case "declined".lowercased():
            self = .declined
        case "error_converting".lowercased():
            self = .errorConverting
        case "error_sending".lowercased():
            self = .errorSending
        case "expired".lowercased():
            self = .expired
        case "finalizing".lowercased():
            self = .finalizing
        case "error_finalizing".lowercased():
            self = .errorFinalizing
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .converting:
            return "converting"
        case .created:
            return "created"
        case .sent:
            return "sent"
        case .viewed:
            return "viewed"
        case .signed:
            return "signed"
        case .cancelled:
            return "cancelled"
        case .declined:
            return "declined"
        case .errorConverting:
            return "error_converting"
        case .errorSending:
            return "error_sending"
        case .expired:
            return "expired"
        case .finalizing:
            return "finalizing"
        case .errorFinalizing:
            return "error_finalizing"
        case .customValue(let value):
            return value
        }
    }

}
