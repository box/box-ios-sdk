import Foundation

/// Request body to start an Automate workflow.
public class AutomateWorkflowStartRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case workflowActionId = "workflow_action_id"
        case fileIds = "file_ids"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The callable action ID used to trigger the selected workflow.
    public let workflowActionId: String

    /// The files to process with the selected workflow.
    public let fileIds: [String]

    /// Initializer for a AutomateWorkflowStartRequestV2026R0.
    ///
    /// - Parameters:
    ///   - workflowActionId: The callable action ID used to trigger the selected workflow.
    ///   - fileIds: The files to process with the selected workflow.
    public init(workflowActionId: String, fileIds: [String]) {
        self.workflowActionId = workflowActionId
        self.fileIds = fileIds
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workflowActionId = try container.decode(String.self, forKey: .workflowActionId)
        fileIds = try container.decode([String].self, forKey: .fileIds)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(workflowActionId, forKey: .workflowActionId)
        try container.encode(fileIds, forKey: .fileIds)
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
