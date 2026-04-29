import Foundation

/// A reference to an Automate workflow.
public class AutomateWorkflowReferenceV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The identifier for the Automate workflow instance.
    public let id: String

    /// The object type.
    public let type: AutomateWorkflowReferenceV2026R0TypeField

    /// The display name for the Automate workflow.
    public let name: String?

    /// Initializer for a AutomateWorkflowReferenceV2026R0.
    ///
    /// - Parameters:
    ///   - id: The identifier for the Automate workflow instance.
    ///   - type: The object type.
    ///   - name: The display name for the Automate workflow.
    public init(id: String, type: AutomateWorkflowReferenceV2026R0TypeField = AutomateWorkflowReferenceV2026R0TypeField.workflow, name: String? = nil) {
        self.id = id
        self.type = type
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(AutomateWorkflowReferenceV2026R0TypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
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
