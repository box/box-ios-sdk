import Foundation

public class WorkflowFlowsOutcomesIfRejectedField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case actionType = "action_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The identifier of the outcome.
    public let id: String?

    /// The outcomes resource type.
    public let type: WorkflowFlowsOutcomesIfRejectedTypeField?

    /// The name of the outcome.
    public let name: String?

    public let actionType: WorkflowFlowsOutcomesIfRejectedActionTypeField?

    /// Initializer for a WorkflowFlowsOutcomesIfRejectedField.
    ///
    /// - Parameters:
    ///   - id: The identifier of the outcome.
    ///   - type: The outcomes resource type.
    ///   - name: The name of the outcome.
    ///   - actionType: 
    public init(id: String? = nil, type: WorkflowFlowsOutcomesIfRejectedTypeField? = nil, name: String? = nil, actionType: WorkflowFlowsOutcomesIfRejectedActionTypeField? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.actionType = actionType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(WorkflowFlowsOutcomesIfRejectedTypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        actionType = try container.decodeIfPresent(WorkflowFlowsOutcomesIfRejectedActionTypeField.self, forKey: .actionType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(actionType, forKey: .actionType)
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
