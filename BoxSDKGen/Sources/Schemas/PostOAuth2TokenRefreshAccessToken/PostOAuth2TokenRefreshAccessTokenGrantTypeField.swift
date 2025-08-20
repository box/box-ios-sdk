import Foundation

public enum PostOAuth2TokenRefreshAccessTokenGrantTypeField: CodableStringEnum {
    case refreshToken
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "refresh_token".lowercased():
            self = .refreshToken
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .refreshToken:
            return "refresh_token"
        case .customValue(let value):
            return value
        }
    }

}
