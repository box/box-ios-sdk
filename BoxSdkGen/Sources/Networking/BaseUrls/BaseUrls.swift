import Foundation

public class BaseUrls: Codable {
    private enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
        case uploadUrl = "upload_url"
        case oauth2Url = "oauth2_url"
    }

    public let baseUrl: String

    public let uploadUrl: String

    public let oauth2Url: String

    public init(baseUrl: String = "https://api.box.com", uploadUrl: String = "https://upload.box.com/api", oauth2Url: String = "https://account.box.com/api/oauth2") {
        self.baseUrl = baseUrl
        self.uploadUrl = uploadUrl
        self.oauth2Url = oauth2Url
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseUrl = try container.decode(String.self, forKey: .baseUrl)
        uploadUrl = try container.decode(String.self, forKey: .uploadUrl)
        oauth2Url = try container.decode(String.self, forKey: .oauth2Url)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseUrl, forKey: .baseUrl)
        try container.encode(uploadUrl, forKey: .uploadUrl)
        try container.encode(oauth2Url, forKey: .oauth2Url)
    }

}
