import Foundation

public class UpdateSlackIntegrationMappingByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case boxItem = "box_item"
        case options
    }

    public let boxItem: IntegrationMappingBoxItemSlack?

    public let options: IntegrationMappingSlackOptions?

    public init(boxItem: IntegrationMappingBoxItemSlack? = nil, options: IntegrationMappingSlackOptions? = nil) {
        self.boxItem = boxItem
        self.options = options
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        boxItem = try container.decodeIfPresent(IntegrationMappingBoxItemSlack.self, forKey: .boxItem)
        options = try container.decodeIfPresent(IntegrationMappingSlackOptions.self, forKey: .options)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(boxItem, forKey: .boxItem)
        try container.encodeIfPresent(options, forKey: .options)
    }

}
