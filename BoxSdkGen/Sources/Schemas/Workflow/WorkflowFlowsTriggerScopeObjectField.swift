import Foundation

public class WorkflowFlowsTriggerScopeObjectField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// The type of the object
    public let type: WorkflowFlowsTriggerScopeObjectTypeField?

    /// The id of the object
    public let id: String?

    /// Initializer for a WorkflowFlowsTriggerScopeObjectField.
    ///
    /// - Parameters:
    ///   - type: The type of the object
    ///   - id: The id of the object
    public init(type: WorkflowFlowsTriggerScopeObjectTypeField? = nil, id: String? = nil) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(WorkflowFlowsTriggerScopeObjectTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
    }

}
