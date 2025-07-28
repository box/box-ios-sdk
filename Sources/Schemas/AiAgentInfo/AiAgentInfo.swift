import Foundation

/// The information on the models and processors used in the request.
public class AiAgentInfo: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case models
        case processor
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The models used for the request.
    public let models: [AiAgentInfoModelsField]?

    /// The processor used for the request.
    public let processor: String?

    /// Initializer for a AiAgentInfo.
    ///
    /// - Parameters:
    ///   - models: The models used for the request.
    ///   - processor: The processor used for the request.
    public init(models: [AiAgentInfoModelsField]? = nil, processor: String? = nil) {
        self.models = models
        self.processor = processor
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        models = try container.decodeIfPresent([AiAgentInfoModelsField].self, forKey: .models)
        processor = try container.decodeIfPresent(String.self, forKey: .processor)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(models, forKey: .models)
        try container.encodeIfPresent(processor, forKey: .processor)
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
