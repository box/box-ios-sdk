import Foundation

public enum TermsOfServiceUserStatusTypeField: CodableStringEnum {
    case termsOfServiceUserStatus
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "terms_of_service_user_status".lowercased():
            self = .termsOfServiceUserStatus
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .termsOfServiceUserStatus:
            return "terms_of_service_user_status"
        case .customValue(let value):
            return value
        }
    }

}
