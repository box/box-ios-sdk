import Foundation

public class FileFullWatermarkInfoField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case isWatermarked = "is_watermarked"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Specifies if this item has a watermark applied.
    public let isWatermarked: Bool?

    /// Initializer for a FileFullWatermarkInfoField.
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
