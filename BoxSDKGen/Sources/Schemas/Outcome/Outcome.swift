import Foundation

/// An instance of an outcome.
public class Outcome: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case collaborators
        case completionRule = "completion_rule"
        case fileCollaboratorRole = "file_collaborator_role"
        case taskCollaborators = "task_collaborators"
        case role
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// ID of a specific outcome.
    public let id: String

    public let collaborators: CollaboratorVariable?

    public let completionRule: CompletionRuleVariable?

    public let fileCollaboratorRole: RoleVariable?

    public let taskCollaborators: CollaboratorVariable?

    public let role: RoleVariable?

    /// Initializer for a Outcome.
    ///
    /// - Parameters:
    ///   - id: ID of a specific outcome.
    ///   - collaborators: 
    ///   - completionRule: 
    ///   - fileCollaboratorRole: 
    ///   - taskCollaborators: 
    ///   - role: 
    public init(id: String, collaborators: CollaboratorVariable? = nil, completionRule: CompletionRuleVariable? = nil, fileCollaboratorRole: RoleVariable? = nil, taskCollaborators: CollaboratorVariable? = nil, role: RoleVariable? = nil) {
        self.id = id
        self.collaborators = collaborators
        self.completionRule = completionRule
        self.fileCollaboratorRole = fileCollaboratorRole
        self.taskCollaborators = taskCollaborators
        self.role = role
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        collaborators = try container.decodeIfPresent(CollaboratorVariable.self, forKey: .collaborators)
        completionRule = try container.decodeIfPresent(CompletionRuleVariable.self, forKey: .completionRule)
        fileCollaboratorRole = try container.decodeIfPresent(RoleVariable.self, forKey: .fileCollaboratorRole)
        taskCollaborators = try container.decodeIfPresent(CollaboratorVariable.self, forKey: .taskCollaborators)
        role = try container.decodeIfPresent(RoleVariable.self, forKey: .role)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(collaborators, forKey: .collaborators)
        try container.encodeIfPresent(completionRule, forKey: .completionRule)
        try container.encodeIfPresent(fileCollaboratorRole, forKey: .fileCollaboratorRole)
        try container.encodeIfPresent(taskCollaborators, forKey: .taskCollaborators)
        try container.encodeIfPresent(role, forKey: .role)
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
