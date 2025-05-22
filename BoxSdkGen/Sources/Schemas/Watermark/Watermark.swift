import Foundation

/// A watermark is a semi-transparent overlay on an embedded file
/// preview that displays a viewer's email address or user ID
/// and the time of access over a file's content
public class Watermark: Codable {
    private enum CodingKeys: String, CodingKey {
        case watermark
    }

    public let watermark: WatermarkWatermarkField?

    public init(watermark: WatermarkWatermarkField? = nil) {
        self.watermark = watermark
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        watermark = try container.decodeIfPresent(WatermarkWatermarkField.self, forKey: .watermark)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(watermark, forKey: .watermark)
    }

}
