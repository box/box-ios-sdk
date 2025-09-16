import Foundation

public class UpdateFileWatermarkRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case watermark
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The watermark to imprint on the file.
    public let watermark: UpdateFileWatermarkRequestBodyWatermarkField

    /// Initializer for a UpdateFileWatermarkRequestBody.
    ///
    /// - Parameters:
    ///   - watermark: The watermark to imprint on the file.
    public init(watermark: UpdateFileWatermarkRequestBodyWatermarkField) {
        self.watermark = watermark
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        watermark = try container.decode(UpdateFileWatermarkRequestBodyWatermarkField.self, forKey: .watermark)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(watermark, forKey: .watermark)
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
