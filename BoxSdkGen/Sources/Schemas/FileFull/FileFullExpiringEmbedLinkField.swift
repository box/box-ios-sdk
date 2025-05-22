import Foundation

public class FileFullExpiringEmbedLinkField: Codable {
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case restrictedTo = "restricted_to"
        case url
    }

    /// The requested access token.
    public let accessToken: String?

    /// The time in seconds by which this token will expire.
    public let expiresIn: Int64?

    /// The type of access token returned.
    public let tokenType: FileFullExpiringEmbedLinkTokenTypeField?

    /// The permissions that this access token permits,
    /// providing a list of resources (files, folders, etc)
    /// and the scopes permitted for each of those resources.
    public let restrictedTo: [FileOrFolderScope]?

    /// The actual expiring embed URL for this file, constructed
    /// from the file ID and access tokens specified in this object.
    public let url: String?

    /// Initializer for a FileFullExpiringEmbedLinkField.
    ///
    /// - Parameters:
    ///   - accessToken: The requested access token.
    ///   - expiresIn: The time in seconds by which this token will expire.
    ///   - tokenType: The type of access token returned.
    ///   - restrictedTo: The permissions that this access token permits,
    ///     providing a list of resources (files, folders, etc)
    ///     and the scopes permitted for each of those resources.
    ///   - url: The actual expiring embed URL for this file, constructed
    ///     from the file ID and access tokens specified in this object.
    public init(accessToken: String? = nil, expiresIn: Int64? = nil, tokenType: FileFullExpiringEmbedLinkTokenTypeField? = nil, restrictedTo: [FileOrFolderScope]? = nil, url: String? = nil) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.restrictedTo = restrictedTo
        self.url = url
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        expiresIn = try container.decodeIfPresent(Int64.self, forKey: .expiresIn)
        tokenType = try container.decodeIfPresent(FileFullExpiringEmbedLinkTokenTypeField.self, forKey: .tokenType)
        restrictedTo = try container.decodeIfPresent([FileOrFolderScope].self, forKey: .restrictedTo)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(accessToken, forKey: .accessToken)
        try container.encodeIfPresent(expiresIn, forKey: .expiresIn)
        try container.encodeIfPresent(tokenType, forKey: .tokenType)
        try container.encodeIfPresent(restrictedTo, forKey: .restrictedTo)
        try container.encodeIfPresent(url, forKey: .url)
    }

}
