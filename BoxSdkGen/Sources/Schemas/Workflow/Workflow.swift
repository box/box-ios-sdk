import Foundation

/// Box Relay Workflows are objects that represent a named collection of flows.
/// 
/// Your application must be authorized to use the `Manage Box Relay` application
/// scope within the developer console in order to use this resource.
public class Workflow: WorkflowMini {
    private enum CodingKeys: String, CodingKey {
        case flows
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// A list of flows assigned to a workflow.
    public let flows: [WorkflowFlowsField]?

    /// Initializer for a Workflow.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the workflow.
    ///   - type: The value will always be `workflow`.
    ///   - name: The name of the workflow.
    ///   - description: The description for a workflow.
    ///   - isEnabled: Specifies if this workflow is enabled.
    ///   - flows: A list of flows assigned to a workflow.
    public init(id: String? = nil, type: WorkflowMiniTypeField? = nil, name: String? = nil, description: String? = nil, isEnabled: Bool? = nil, flows: [WorkflowFlowsField]? = nil) {
        self.flows = flows

        super.init(id: id, type: type, name: name, description: description, isEnabled: isEnabled)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        flows = try container.decodeIfPresent([WorkflowFlowsField].self, forKey: .flows)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(flows, forKey: .flows)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
