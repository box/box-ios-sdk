import Foundation

public enum PostOAuth2TokenGrantTypeField: CodableStringEnum {
    case authorizationCode
    case refreshToken
    case clientCredentials
    case urnIetfParamsOauthGrantTypeJwtBearer
    case urnIetfParamsOauthGrantTypeTokenExchange
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "authorization_code".lowercased():
            self = .authorizationCode
        case "refresh_token".lowercased():
            self = .refreshToken
        case "client_credentials".lowercased():
            self = .clientCredentials
        case "urn:ietf:params:oauth:grant-type:jwt-bearer".lowercased():
            self = .urnIetfParamsOauthGrantTypeJwtBearer
        case "urn:ietf:params:oauth:grant-type:token-exchange".lowercased():
            self = .urnIetfParamsOauthGrantTypeTokenExchange
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .authorizationCode:
            return "authorization_code"
        case .refreshToken:
            return "refresh_token"
        case .clientCredentials:
            return "client_credentials"
        case .urnIetfParamsOauthGrantTypeJwtBearer:
            return "urn:ietf:params:oauth:grant-type:jwt-bearer"
        case .urnIetfParamsOauthGrantTypeTokenExchange:
            return "urn:ietf:params:oauth:grant-type:token-exchange"
        case .customValue(let value):
            return value
        }
    }

}
