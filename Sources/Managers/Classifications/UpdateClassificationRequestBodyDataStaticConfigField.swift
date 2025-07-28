import Foundation

public class UpdateClassificationRequestBodyDataStaticConfigField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case classification
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Additional details for the classification.
    public let classification: UpdateClassificationRequestBodyDataStaticConfigClassificationField?

    /// Initializer for a UpdateClassificationRequestBodyDataStaticConfigField.
    ///
    /// - Parameters:
    ///   - classification: Additional details for the classification.
    public init(classification: UpdateClassificationRequestBodyDataStaticConfigClassificationField? = nil) {
        self.classification = classification
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classification = try container.decodeIfPresent(UpdateClassificationRequestBodyDataStaticConfigClassificationField.self, forKey: .classification)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(classification, forKey: .classification)
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
