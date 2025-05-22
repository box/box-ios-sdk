import Foundation

public class UpdateFolderWatermarkRequestBodyWatermarkField: Codable {
    private enum CodingKeys: String, CodingKey {
        case imprint
    }

    /// The type of watermark to apply.
    /// 
    /// Currently only supports one option.
    public let imprint: UpdateFolderWatermarkRequestBodyWatermarkImprintField

    /// Initializer for a UpdateFolderWatermarkRequestBodyWatermarkField.
    ///
    /// - Parameters:
    ///   - imprint: The type of watermark to apply.
    ///     
    ///     Currently only supports one option.
    public init(imprint: UpdateFolderWatermarkRequestBodyWatermarkImprintField = UpdateFolderWatermarkRequestBodyWatermarkImprintField.default_) {
        self.imprint = imprint
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imprint = try container.decode(UpdateFolderWatermarkRequestBodyWatermarkImprintField.self, forKey: .imprint)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imprint, forKey: .imprint)
    }

}
