import Foundation

public class DocGenBatchCreateRequestV2025R0DestinationFolderField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// ID of the folder
    public let id: String

    /// `folder`
    public let type: DocGenBatchCreateRequestV2025R0DestinationFolderTypeField

    /// Initializer for a DocGenBatchCreateRequestV2025R0DestinationFolderField.
    ///
    /// - Parameters:
    ///   - id: ID of the folder
    ///   - type: `folder`
    public init(id: String, type: DocGenBatchCreateRequestV2025R0DestinationFolderTypeField = DocGenBatchCreateRequestV2025R0DestinationFolderTypeField.folder) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(DocGenBatchCreateRequestV2025R0DestinationFolderTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
