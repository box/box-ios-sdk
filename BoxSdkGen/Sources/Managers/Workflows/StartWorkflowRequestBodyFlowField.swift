import Foundation

public class StartWorkflowRequestBodyFlowField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// The type of the flow object
    public let type: String?

    /// The id of the flow
    public let id: String?

    /// Initializer for a StartWorkflowRequestBodyFlowField.
    ///
    /// - Parameters:
    ///   - type: The type of the flow object
    ///   - id: The id of the flow
    public init(type: String? = nil, id: String? = nil) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
    }

}
