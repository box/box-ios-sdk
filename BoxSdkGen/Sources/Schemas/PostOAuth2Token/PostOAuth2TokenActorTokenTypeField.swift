import Foundation

public enum PostOAuth2TokenActorTokenTypeField: CodableStringEnum {
    case urnIetfParamsOauthTokenTypeIdToken
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "urn:ietf:params:oauth:token-type:id_token".lowercased():
            self = .urnIetfParamsOauthTokenTypeIdToken
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .urnIetfParamsOauthTokenTypeIdToken:
            return "urn:ietf:params:oauth:token-type:id_token"
        case .customValue(let value):
            return value
        }
    }

}
