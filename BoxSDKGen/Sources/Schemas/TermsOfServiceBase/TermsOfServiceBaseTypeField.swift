import Foundation

public enum TermsOfServiceBaseTypeField: CodableStringEnum {
    case termsOfService
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "terms_of_service".lowercased():
            self = .termsOfService
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .termsOfService:
            return "terms_of_service"
        case .customValue(let value):
            return value
        }
    }

}
