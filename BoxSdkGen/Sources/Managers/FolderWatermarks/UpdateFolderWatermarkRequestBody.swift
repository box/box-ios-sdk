import Foundation

public class UpdateFolderWatermarkRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case watermark
    }

    /// The watermark to imprint on the folder
    public let watermark: UpdateFolderWatermarkRequestBodyWatermarkField

    /// Initializer for a UpdateFolderWatermarkRequestBody.
    ///
    /// - Parameters:
    ///   - watermark: The watermark to imprint on the folder
    public init(watermark: UpdateFolderWatermarkRequestBodyWatermarkField) {
        self.watermark = watermark
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        watermark = try container.decode(UpdateFolderWatermarkRequestBodyWatermarkField.self, forKey: .watermark)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(watermark, forKey: .watermark)
    }

}
