import Foundation

public class UserAvatarPicUrlsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case small
        case large
        case preview
    }

    /// The location of a small-sized avatar.
    public let small: String?

    /// The location of a large-sized avatar.
    public let large: String?

    /// The location of the avatar preview.
    public let preview: String?

    /// Initializer for a UserAvatarPicUrlsField.
    ///
    /// - Parameters:
    ///   - small: The location of a small-sized avatar.
    ///   - large: The location of a large-sized avatar.
    ///   - preview: The location of the avatar preview.
    public init(small: String? = nil, large: String? = nil, preview: String? = nil) {
        self.small = small
        self.large = large
        self.preview = preview
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        small = try container.decodeIfPresent(String.self, forKey: .small)
        large = try container.decodeIfPresent(String.self, forKey: .large)
        preview = try container.decodeIfPresent(String.self, forKey: .preview)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(small, forKey: .small)
        try container.encodeIfPresent(large, forKey: .large)
        try container.encodeIfPresent(preview, forKey: .preview)
    }

}
