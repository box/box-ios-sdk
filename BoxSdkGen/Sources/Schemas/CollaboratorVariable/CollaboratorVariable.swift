import Foundation

/// A collaborator
/// object. Allows to
/// specify a list of user
/// ID's that are affected
/// by the workflow result.
public class CollaboratorVariable: Codable {
    private enum CodingKeys: String, CodingKey {
        case variableValue = "variable_value"
        case type
        case variableType = "variable_type"
    }

    /// A list of user IDs.
    public let variableValue: [CollaboratorVariableVariableValueField]

    /// Collaborator
    /// object type.
    /// 
    public let type: CollaboratorVariableTypeField

    /// Variable type 
    /// for the Collaborator
    /// object.
    /// 
    public let variableType: CollaboratorVariableVariableTypeField

    /// Initializer for a CollaboratorVariable.
    ///
    /// - Parameters:
    ///   - variableValue: A list of user IDs.
    ///   - type: Collaborator
    ///     object type.
    ///     
    ///   - variableType: Variable type 
    ///     for the Collaborator
    ///     object.
    ///     
    public init(variableValue: [CollaboratorVariableVariableValueField], type: CollaboratorVariableTypeField = CollaboratorVariableTypeField.variable, variableType: CollaboratorVariableVariableTypeField = CollaboratorVariableVariableTypeField.userList) {
        self.variableValue = variableValue
        self.type = type
        self.variableType = variableType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        variableValue = try container.decode([CollaboratorVariableVariableValueField].self, forKey: .variableValue)
        type = try container.decode(CollaboratorVariableTypeField.self, forKey: .type)
        variableType = try container.decode(CollaboratorVariableVariableTypeField.self, forKey: .variableType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(variableValue, forKey: .variableValue)
        try container.encode(type, forKey: .type)
        try container.encode(variableType, forKey: .variableType)
    }

}
