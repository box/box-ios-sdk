import Foundation

/// A resource holding URLs to the
/// avatar uploaded to a Box application.
public class UserAvatar: Codable {
    private enum CodingKeys: String, CodingKey {
        case picUrls = "pic_urls"
    }

    /// Represents an object with user avatar URLs.
    public let picUrls: UserAvatarPicUrlsField?

    /// Initializer for a UserAvatar.
    ///
    /// - Parameters:
    ///   - picUrls: Represents an object with user avatar URLs.
    public init(picUrls: UserAvatarPicUrlsField? = nil) {
        self.picUrls = picUrls
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        picUrls = try container.decodeIfPresent(UserAvatarPicUrlsField.self, forKey: .picUrls)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(picUrls, forKey: .picUrls)
    }

}
