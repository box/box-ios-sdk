import Foundation

public class UpdateTeamsIntegrationMappingByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case boxItem = "box_item"
    }

    public let boxItem: FolderReference?

    public init(boxItem: FolderReference? = nil) {
        self.boxItem = boxItem
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        boxItem = try container.decodeIfPresent(FolderReference.self, forKey: .boxItem)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(boxItem, forKey: .boxItem)
    }

}
