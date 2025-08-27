import Foundation

public class UserAvatarPicUrlsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case small
        case large
        case preview
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
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

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
