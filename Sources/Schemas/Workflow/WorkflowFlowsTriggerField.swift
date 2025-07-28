import Foundation

public class WorkflowFlowsTriggerField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case triggerType = "trigger_type"
        case scope
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The trigger's resource type.
    public let type: WorkflowFlowsTriggerTypeField?

    /// The type of trigger selected for this flow.
    public let triggerType: WorkflowFlowsTriggerTriggerTypeField?

    /// List of trigger scopes.
    public let scope: [WorkflowFlowsTriggerScopeField]?

    /// Initializer for a WorkflowFlowsTriggerField.
    ///
    /// - Parameters:
    ///   - type: The trigger's resource type.
    ///   - triggerType: The type of trigger selected for this flow.
    ///   - scope: List of trigger scopes.
    public init(type: WorkflowFlowsTriggerTypeField? = nil, triggerType: WorkflowFlowsTriggerTriggerTypeField? = nil, scope: [WorkflowFlowsTriggerScopeField]? = nil) {
        self.type = type
        self.triggerType = triggerType
        self.scope = scope
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(WorkflowFlowsTriggerTypeField.self, forKey: .type)
        triggerType = try container.decodeIfPresent(WorkflowFlowsTriggerTriggerTypeField.self, forKey: .triggerType)
        scope = try container.decodeIfPresent([WorkflowFlowsTriggerScopeField].self, forKey: .scope)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(triggerType, forKey: .triggerType)
        try container.encodeIfPresent(scope, forKey: .scope)
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
