import Foundation

/// A request to create a Slack Integration Mapping object.
public class IntegrationMappingSlackCreateRequest: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case partnerItem = "partner_item"
        case boxItem = "box_item"
        case options
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    public let partnerItem: IntegrationMappingPartnerItemSlack

    public let boxItem: IntegrationMappingBoxItemSlack

    public let options: IntegrationMappingSlackOptions?

    public init(partnerItem: IntegrationMappingPartnerItemSlack, boxItem: IntegrationMappingBoxItemSlack, options: IntegrationMappingSlackOptions? = nil) {
        self.partnerItem = partnerItem
        self.boxItem = boxItem
        self.options = options
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        partnerItem = try container.decode(IntegrationMappingPartnerItemSlack.self, forKey: .partnerItem)
        boxItem = try container.decode(IntegrationMappingBoxItemSlack.self, forKey: .boxItem)
        options = try container.decodeIfPresent(IntegrationMappingSlackOptions.self, forKey: .options)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(partnerItem, forKey: .partnerItem)
        try container.encode(boxItem, forKey: .boxItem)
        try container.encodeIfPresent(options, forKey: .options)
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
