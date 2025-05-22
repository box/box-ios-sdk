import Foundation

public class StartWorkflowRequestBodyFolderField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// The type of the folder object
    public let type: StartWorkflowRequestBodyFolderTypeField?

    /// The id of the folder
    public let id: String?

    /// Initializer for a StartWorkflowRequestBodyFolderField.
    ///
    /// - Parameters:
    ///   - type: The type of the folder object
    ///   - id: The id of the folder
    public init(type: StartWorkflowRequestBodyFolderTypeField? = nil, id: String? = nil) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(StartWorkflowRequestBodyFolderTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
    }

}
