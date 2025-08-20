import Foundation

public class WorkflowFlowsTriggerScopeField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case ref
        case object
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The trigger scope's resource type.
    public let type: WorkflowFlowsTriggerScopeTypeField?

    /// Indicates the path of the condition value to check.
    public let ref: String?

    /// The object the `ref` points to.
    public let object: WorkflowFlowsTriggerScopeObjectField?

    /// Initializer for a WorkflowFlowsTriggerScopeField.
    ///
    /// - Parameters:
    ///   - type: The trigger scope's resource type.
    ///   - ref: Indicates the path of the condition value to check.
    ///   - object: The object the `ref` points to.
    public init(type: WorkflowFlowsTriggerScopeTypeField? = nil, ref: String? = nil, object: WorkflowFlowsTriggerScopeObjectField? = nil) {
        self.type = type
        self.ref = ref
        self.object = object
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(WorkflowFlowsTriggerScopeTypeField.self, forKey: .type)
        ref = try container.decodeIfPresent(String.self, forKey: .ref)
        object = try container.decodeIfPresent(WorkflowFlowsTriggerScopeObjectField.self, forKey: .object)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(ref, forKey: .ref)
        try container.encodeIfPresent(object, forKey: .object)
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
