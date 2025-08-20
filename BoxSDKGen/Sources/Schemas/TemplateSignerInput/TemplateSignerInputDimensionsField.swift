import Foundation

public class TemplateSignerInputDimensionsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case width
        case height
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Relative width to the page the input is on, ranging from 0 to 1.
    public let width: Double?

    /// Relative height to the page the input is on, ranging from 0 to 1.
    public let height: Double?

    /// Initializer for a TemplateSignerInputDimensionsField.
    ///
    /// - Parameters:
    ///   - width: Relative width to the page the input is on, ranging from 0 to 1.
    ///   - height: Relative height to the page the input is on, ranging from 0 to 1.
    public init(width: Double? = nil, height: Double? = nil) {
        self.width = width
        self.height = height
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        width = try container.decodeIfPresent(Double.self, forKey: .width)
        height = try container.decodeIfPresent(Double.self, forKey: .height)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(width, forKey: .width)
        try container.encodeIfPresent(height, forKey: .height)
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
