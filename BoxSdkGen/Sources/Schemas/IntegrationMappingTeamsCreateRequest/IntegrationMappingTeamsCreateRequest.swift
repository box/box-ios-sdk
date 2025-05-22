import Foundation

/// A request to create a Teams Integration Mapping object
public class IntegrationMappingTeamsCreateRequest: Codable {
    private enum CodingKeys: String, CodingKey {
        case partnerItem = "partner_item"
        case boxItem = "box_item"
    }

    public let partnerItem: IntegrationMappingPartnerItemTeamsCreateRequest

    public let boxItem: FolderReference

    public init(partnerItem: IntegrationMappingPartnerItemTeamsCreateRequest, boxItem: FolderReference) {
        self.partnerItem = partnerItem
        self.boxItem = boxItem
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        partnerItem = try container.decode(IntegrationMappingPartnerItemTeamsCreateRequest.self, forKey: .partnerItem)
        boxItem = try container.decode(FolderReference.self, forKey: .boxItem)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(partnerItem, forKey: .partnerItem)
        try container.encode(boxItem, forKey: .boxItem)
    }

}
