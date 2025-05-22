import Foundation

public class FolderFullWatermarkInfoField: Codable {
    private enum CodingKeys: String, CodingKey {
        case isWatermarked = "is_watermarked"
    }

    /// Specifies if this item has a watermark applied.
    public let isWatermarked: Bool?

    /// Initializer for a FolderFullWatermarkInfoField.
    ///
    /// - Parameters:
    ///   - isWatermarked: Specifies if this item has a watermark applied.
    public init(isWatermarked: Bool? = nil) {
        self.isWatermarked = isWatermarked
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isWatermarked = try container.decodeIfPresent(Bool.self, forKey: .isWatermarked)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isWatermarked, forKey: .isWatermarked)
    }

}
