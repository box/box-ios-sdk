import Foundation

public enum UpdateAllSkillCardsOnFileRequestBodyStatusField: CodableStringEnum {
    case invoked
    case processing
    case success
    case transientFailure
    case permanentFailure
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "invoked".lowercased():
            self = .invoked
        case "processing".lowercased():
            self = .processing
        case "success".lowercased():
            self = .success
        case "transient_failure".lowercased():
            self = .transientFailure
        case "permanent_failure".lowercased():
            self = .permanentFailure
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .invoked:
            return "invoked"
        case .processing:
            return "processing"
        case .success:
            return "success"
        case .transientFailure:
            return "transient_failure"
        case .permanentFailure:
            return "permanent_failure"
        case .customValue(let value):
            return value
        }
    }

}
