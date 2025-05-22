import Foundation

/// A request for a new OAuth 2.0 token
public class PostOAuth2Token: Codable {
    private enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case code
        case refreshToken = "refresh_token"
        case assertion
        case subjectToken = "subject_token"
        case subjectTokenType = "subject_token_type"
        case actorToken = "actor_token"
        case actorTokenType = "actor_token_type"
        case scope
        case resource
        case boxSubjectType = "box_subject_type"
        case boxSubjectId = "box_subject_id"
        case boxSharedLink = "box_shared_link"
    }

    /// The type of request being made, either using a client-side obtained
    /// authorization code, a refresh token, a JWT assertion, client credentials
    /// grant or another access token for the purpose of downscoping a token.
    public let grantType: PostOAuth2TokenGrantTypeField

    /// The Client ID of the application requesting an access token.
    /// 
    /// Used in combination with `authorization_code`, `client_credentials`, or
    /// `urn:ietf:params:oauth:grant-type:jwt-bearer` as the `grant_type`.
    public let clientId: String?

    /// The client secret of the application requesting an access token.
    /// 
    /// Used in combination with `authorization_code`, `client_credentials`, or
    /// `urn:ietf:params:oauth:grant-type:jwt-bearer` as the `grant_type`.
    public let clientSecret: String?

    /// The client-side authorization code passed to your application by
    /// Box in the browser redirect after the user has successfully
    /// granted your application permission to make API calls on their
    /// behalf.
    /// 
    /// Used in combination with `authorization_code` as the `grant_type`.
    public let code: String?

    /// A refresh token used to get a new access token with.
    /// 
    /// Used in combination with `refresh_token` as the `grant_type`.
    public let refreshToken: String?

    /// A JWT assertion for which to request a new access token.
    /// 
    /// Used in combination with `urn:ietf:params:oauth:grant-type:jwt-bearer`
    /// as the `grant_type`.
    public let assertion: String?

    /// The token to exchange for a downscoped token. This can be a regular
    /// access token, a JWT assertion, or an app token.
    /// 
    /// Used in combination with `urn:ietf:params:oauth:grant-type:token-exchange`
    /// as the `grant_type`.
    public let subjectToken: String?

    /// The type of `subject_token` passed in.
    /// 
    /// Used in combination with `urn:ietf:params:oauth:grant-type:token-exchange`
    /// as the `grant_type`.
    public let subjectTokenType: PostOAuth2TokenSubjectTokenTypeField?

    /// The token used to create an annotator token.
    /// This is a JWT assertion.
    /// 
    /// Used in combination with `urn:ietf:params:oauth:grant-type:token-exchange`
    /// as the `grant_type`.
    public let actorToken: String?

    /// The type of `actor_token` passed in.
    /// 
    /// Used in combination with `urn:ietf:params:oauth:grant-type:token-exchange`
    /// as the `grant_type`.
    public let actorTokenType: PostOAuth2TokenActorTokenTypeField?

    /// The space-delimited list of scopes that you want apply to the
    /// new access token.
    /// 
    /// The `subject_token` will need to have all of these scopes or
    /// the call will error with **401 Unauthorized**.
    public let scope: String?

    /// Full URL for the file that the token should be generated for.
    public let resource: String?

    /// Used in combination with `client_credentials` as the `grant_type`.
    public let boxSubjectType: PostOAuth2TokenBoxSubjectTypeField?

    /// Used in combination with `client_credentials` as the `grant_type`.
    /// Value is determined by `box_subject_type`. If `user` use user ID and if
    /// `enterprise` use enterprise ID.
    public let boxSubjectId: String?

    /// Full URL of the shared link on the file or folder
    /// that the token should be generated for.
    public let boxSharedLink: String?

    /// Initializer for a PostOAuth2Token.
    ///
    /// - Parameters:
    ///   - grantType: The type of request being made, either using a client-side obtained
    ///     authorization code, a refresh token, a JWT assertion, client credentials
    ///     grant or another access token for the purpose of downscoping a token.
    ///   - clientId: The Client ID of the application requesting an access token.
    ///     
    ///     Used in combination with `authorization_code`, `client_credentials`, or
    ///     `urn:ietf:params:oauth:grant-type:jwt-bearer` as the `grant_type`.
    ///   - clientSecret: The client secret of the application requesting an access token.
    ///     
    ///     Used in combination with `authorization_code`, `client_credentials`, or
    ///     `urn:ietf:params:oauth:grant-type:jwt-bearer` as the `grant_type`.
    ///   - code: The client-side authorization code passed to your application by
    ///     Box in the browser redirect after the user has successfully
    ///     granted your application permission to make API calls on their
    ///     behalf.
    ///     
    ///     Used in combination with `authorization_code` as the `grant_type`.
    ///   - refreshToken: A refresh token used to get a new access token with.
    ///     
    ///     Used in combination with `refresh_token` as the `grant_type`.
    ///   - assertion: A JWT assertion for which to request a new access token.
    ///     
    ///     Used in combination with `urn:ietf:params:oauth:grant-type:jwt-bearer`
    ///     as the `grant_type`.
    ///   - subjectToken: The token to exchange for a downscoped token. This can be a regular
    ///     access token, a JWT assertion, or an app token.
    ///     
    ///     Used in combination with `urn:ietf:params:oauth:grant-type:token-exchange`
    ///     as the `grant_type`.
    ///   - subjectTokenType: The type of `subject_token` passed in.
    ///     
    ///     Used in combination with `urn:ietf:params:oauth:grant-type:token-exchange`
    ///     as the `grant_type`.
    ///   - actorToken: The token used to create an annotator token.
    ///     This is a JWT assertion.
    ///     
    ///     Used in combination with `urn:ietf:params:oauth:grant-type:token-exchange`
    ///     as the `grant_type`.
    ///   - actorTokenType: The type of `actor_token` passed in.
    ///     
    ///     Used in combination with `urn:ietf:params:oauth:grant-type:token-exchange`
    ///     as the `grant_type`.
    ///   - scope: The space-delimited list of scopes that you want apply to the
    ///     new access token.
    ///     
    ///     The `subject_token` will need to have all of these scopes or
    ///     the call will error with **401 Unauthorized**.
    ///   - resource: Full URL for the file that the token should be generated for.
    ///   - boxSubjectType: Used in combination with `client_credentials` as the `grant_type`.
    ///   - boxSubjectId: Used in combination with `client_credentials` as the `grant_type`.
    ///     Value is determined by `box_subject_type`. If `user` use user ID and if
    ///     `enterprise` use enterprise ID.
    ///   - boxSharedLink: Full URL of the shared link on the file or folder
    ///     that the token should be generated for.
    public init(grantType: PostOAuth2TokenGrantTypeField, clientId: String? = nil, clientSecret: String? = nil, code: String? = nil, refreshToken: String? = nil, assertion: String? = nil, subjectToken: String? = nil, subjectTokenType: PostOAuth2TokenSubjectTokenTypeField? = nil, actorToken: String? = nil, actorTokenType: PostOAuth2TokenActorTokenTypeField? = nil, scope: String? = nil, resource: String? = nil, boxSubjectType: PostOAuth2TokenBoxSubjectTypeField? = nil, boxSubjectId: String? = nil, boxSharedLink: String? = nil) {
        self.grantType = grantType
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.code = code
        self.refreshToken = refreshToken
        self.assertion = assertion
        self.subjectToken = subjectToken
        self.subjectTokenType = subjectTokenType
        self.actorToken = actorToken
        self.actorTokenType = actorTokenType
        self.scope = scope
        self.resource = resource
        self.boxSubjectType = boxSubjectType
        self.boxSubjectId = boxSubjectId
        self.boxSharedLink = boxSharedLink
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        grantType = try container.decode(PostOAuth2TokenGrantTypeField.self, forKey: .grantType)
        clientId = try container.decodeIfPresent(String.self, forKey: .clientId)
        clientSecret = try container.decodeIfPresent(String.self, forKey: .clientSecret)
        code = try container.decodeIfPresent(String.self, forKey: .code)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        assertion = try container.decodeIfPresent(String.self, forKey: .assertion)
        subjectToken = try container.decodeIfPresent(String.self, forKey: .subjectToken)
        subjectTokenType = try container.decodeIfPresent(PostOAuth2TokenSubjectTokenTypeField.self, forKey: .subjectTokenType)
        actorToken = try container.decodeIfPresent(String.self, forKey: .actorToken)
        actorTokenType = try container.decodeIfPresent(PostOAuth2TokenActorTokenTypeField.self, forKey: .actorTokenType)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)
        resource = try container.decodeIfPresent(String.self, forKey: .resource)
        boxSubjectType = try container.decodeIfPresent(PostOAuth2TokenBoxSubjectTypeField.self, forKey: .boxSubjectType)
        boxSubjectId = try container.decodeIfPresent(String.self, forKey: .boxSubjectId)
        boxSharedLink = try container.decodeIfPresent(String.self, forKey: .boxSharedLink)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(grantType, forKey: .grantType)
        try container.encodeIfPresent(clientId, forKey: .clientId)
        try container.encodeIfPresent(clientSecret, forKey: .clientSecret)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(refreshToken, forKey: .refreshToken)
        try container.encodeIfPresent(assertion, forKey: .assertion)
        try container.encodeIfPresent(subjectToken, forKey: .subjectToken)
        try container.encodeIfPresent(subjectTokenType, forKey: .subjectTokenType)
        try container.encodeIfPresent(actorToken, forKey: .actorToken)
        try container.encodeIfPresent(actorTokenType, forKey: .actorTokenType)
        try container.encodeIfPresent(scope, forKey: .scope)
        try container.encodeIfPresent(resource, forKey: .resource)
        try container.encodeIfPresent(boxSubjectType, forKey: .boxSubjectType)
        try container.encodeIfPresent(boxSubjectId, forKey: .boxSubjectId)
        try container.encodeIfPresent(boxSharedLink, forKey: .boxSharedLink)
    }

}
