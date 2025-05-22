import Foundation

public class StartWorkflowRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case flow
        case files
        case folder
        case type
        case outcomes
    }

    /// The flow that will be triggered
    public let flow: StartWorkflowRequestBodyFlowField

    /// The array of files for which the workflow should start. All files
    /// must be in the workflow's configured folder.
    public let files: [StartWorkflowRequestBodyFilesField]

    /// The folder object for which the workflow is configured.
    public let folder: StartWorkflowRequestBodyFolderField

    /// The type of the parameters object
    public let type: StartWorkflowRequestBodyTypeField?

    /// A configurable outcome the workflow should complete.
    public let outcomes: [Outcome]?

    /// Initializer for a StartWorkflowRequestBody.
    ///
    /// - Parameters:
    ///   - flow: The flow that will be triggered
    ///   - files: The array of files for which the workflow should start. All files
    ///     must be in the workflow's configured folder.
    ///   - folder: The folder object for which the workflow is configured.
    ///   - type: The type of the parameters object
    ///   - outcomes: A configurable outcome the workflow should complete.
    public init(flow: StartWorkflowRequestBodyFlowField, files: [StartWorkflowRequestBodyFilesField], folder: StartWorkflowRequestBodyFolderField, type: StartWorkflowRequestBodyTypeField? = nil, outcomes: [Outcome]? = nil) {
        self.flow = flow
        self.files = files
        self.folder = folder
        self.type = type
        self.outcomes = outcomes
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        flow = try container.decode(StartWorkflowRequestBodyFlowField.self, forKey: .flow)
        files = try container.decode([StartWorkflowRequestBodyFilesField].self, forKey: .files)
        folder = try container.decode(StartWorkflowRequestBodyFolderField.self, forKey: .folder)
        type = try container.decodeIfPresent(StartWorkflowRequestBodyTypeField.self, forKey: .type)
        outcomes = try container.decodeIfPresent([Outcome].self, forKey: .outcomes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(flow, forKey: .flow)
        try container.encode(files, forKey: .files)
        try container.encode(folder, forKey: .folder)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(outcomes, forKey: .outcomes)
    }

}
