import Foundation

public class FolderFullWatermarkInfoField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case isWatermarked = "is_watermarked"
        case isWatermarkInherited = "is_watermark_inherited"
        case isWatermarkedByAccessPolicy = "is_watermarked_by_access_policy"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Specifies if this item has a watermark applied.
    public let isWatermarked: Bool?

    /// Specifies if the watermark is inherited from any parent folder in the hierarchy.
    public let isWatermarkInherited: Bool?

    /// Specifies if the watermark is enforced by an access policy.
    public let isWatermarkedByAccessPolicy: Bool?

    /// Initializer for a FolderFullWatermarkInfoField.
    ///
    /// - Parameters:
    ///   - isWatermarked: Specifies if this item has a watermark applied.
    ///   - isWatermarkInherited: Specifies if the watermark is inherited from any parent folder in the hierarchy.
    ///   - isWatermarkedByAccessPolicy: Specifies if the watermark is enforced by an access policy.
    public init(isWatermarked: Bool? = nil, isWatermarkInherited: Bool? = nil, isWatermarkedByAccessPolicy: Bool? = nil) {
        self.isWatermarked = isWatermarked
        self.isWatermarkInherited = isWatermarkInherited
        self.isWatermarkedByAccessPolicy = isWatermarkedByAccessPolicy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isWatermarked = try container.decodeIfPresent(Bool.self, forKey: .isWatermarked)
        isWatermarkInherited = try container.decodeIfPresent(Bool.self, forKey: .isWatermarkInherited)
        isWatermarkedByAccessPolicy = try container.decodeIfPresent(Bool.self, forKey: .isWatermarkedByAccessPolicy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isWatermarked, forKey: .isWatermarked)
        try container.encodeIfPresent(isWatermarkInherited, forKey: .isWatermarkInherited)
        try container.encodeIfPresent(isWatermarkedByAccessPolicy, forKey: .isWatermarkedByAccessPolicy)
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
