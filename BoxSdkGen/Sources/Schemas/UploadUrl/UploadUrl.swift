import Foundation

/// The details for the upload session for the file.
public class UploadUrl: Codable {
    private enum CodingKeys: String, CodingKey {
        case uploadUrl = "upload_url"
        case uploadToken = "upload_token"
    }

    /// A URL for an upload session that can be used to upload
    /// the file.
    public let uploadUrl: String?

    /// An optional access token to use to upload the file
    public let uploadToken: String?

    /// Initializer for a UploadUrl.
    ///
    /// - Parameters:
    ///   - uploadUrl: A URL for an upload session that can be used to upload
    ///     the file.
    ///   - uploadToken: An optional access token to use to upload the file
    public init(uploadUrl: String? = nil, uploadToken: String? = nil) {
        self.uploadUrl = uploadUrl
        self.uploadToken = uploadToken
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uploadUrl = try container.decodeIfPresent(String.self, forKey: .uploadUrl)
        uploadToken = try container.decodeIfPresent(String.self, forKey: .uploadToken)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(uploadUrl, forKey: .uploadUrl)
        try container.encodeIfPresent(uploadToken, forKey: .uploadToken)
    }

}
