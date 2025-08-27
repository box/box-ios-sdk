import Foundation

public class UpdateClassificationRequestBodyDataStaticConfigClassificationField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case classificationDefinition
        case colorId = "colorID"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A longer description of the classification.
    public let classificationDefinition: String?

    /// An internal Box identifier used to assign a color to
    /// a classification label.
    /// 
    /// Mapping between a `colorID` and a color may change
    /// without notice. Currently, the color mappings are as
    /// follows.
    /// 
    /// * `0`: Yellow.
    /// * `1`: Orange.
    /// * `2`: Watermelon red.
    /// * `3`: Purple rain.
    /// * `4`: Light blue.
    /// * `5`: Dark blue.
    /// * `6`: Light green.
    /// * `7`: Gray.
    public let colorId: Int64?

    /// Initializer for a UpdateClassificationRequestBodyDataStaticConfigClassificationField.
    ///
    /// - Parameters:
    ///   - classificationDefinition: A longer description of the classification.
    ///   - colorId: An internal Box identifier used to assign a color to
    ///     a classification label.
    ///     
    ///     Mapping between a `colorID` and a color may change
    ///     without notice. Currently, the color mappings are as
    ///     follows.
    ///     
    ///     * `0`: Yellow.
    ///     * `1`: Orange.
    ///     * `2`: Watermelon red.
    ///     * `3`: Purple rain.
    ///     * `4`: Light blue.
    ///     * `5`: Dark blue.
    ///     * `6`: Light green.
    ///     * `7`: Gray.
    public init(classificationDefinition: String? = nil, colorId: Int64? = nil) {
        self.classificationDefinition = classificationDefinition
        self.colorId = colorId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classificationDefinition = try container.decodeIfPresent(String.self, forKey: .classificationDefinition)
        colorId = try container.decodeIfPresent(Int64.self, forKey: .colorId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(classificationDefinition, forKey: .classificationDefinition)
        try container.encodeIfPresent(colorId, forKey: .colorId)
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
