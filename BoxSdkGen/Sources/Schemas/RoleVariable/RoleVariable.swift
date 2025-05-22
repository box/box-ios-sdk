import Foundation

/// Determines if the
/// workflow outcome
/// affects a specific
/// collaborator role.
public class RoleVariable: Codable {
    private enum CodingKeys: String, CodingKey {
        case variableValue = "variable_value"
        case type
        case variableType = "variable_type"
    }

    public let variableValue: RoleVariableVariableValueField

    /// Role object type.
    /// 
    public let type: RoleVariableTypeField

    /// The variable type used
    /// by the object.
    /// 
    public let variableType: RoleVariableVariableTypeField

    /// Initializer for a RoleVariable.
    ///
    /// - Parameters:
    ///   - variableValue: 
    ///   - type: Role object type.
    ///     
    ///   - variableType: The variable type used
    ///     by the object.
    ///     
    public init(variableValue: RoleVariableVariableValueField, type: RoleVariableTypeField = RoleVariableTypeField.variable, variableType: RoleVariableVariableTypeField = RoleVariableVariableTypeField.collaboratorRole) {
        self.variableValue = variableValue
        self.type = type
        self.variableType = variableType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        variableValue = try container.decode(RoleVariableVariableValueField.self, forKey: .variableValue)
        type = try container.decode(RoleVariableTypeField.self, forKey: .type)
        variableType = try container.decode(RoleVariableVariableTypeField.self, forKey: .variableType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(variableValue, forKey: .variableValue)
        try container.encode(type, forKey: .type)
        try container.encode(variableType, forKey: .variableType)
    }

}
