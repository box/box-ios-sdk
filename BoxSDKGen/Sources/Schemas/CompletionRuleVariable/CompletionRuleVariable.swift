import Foundation

/// A completion
/// rule object. Determines
/// if an action should be completed
/// by all or any assignees.
public class CompletionRuleVariable: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case variableValue = "variable_value"
        case type
        case variableType = "variable_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Variable
    /// values for a completion
    /// rule.
    public let variableValue: CompletionRuleVariableVariableValueField

    /// Completion
    /// Rule object type.
    public let type: CompletionRuleVariableTypeField

    /// Variable type
    /// for the Completion
    /// Rule object.
    public let variableType: CompletionRuleVariableVariableTypeField

    /// Initializer for a CompletionRuleVariable.
    ///
    /// - Parameters:
    ///   - variableValue: Variable
    ///     values for a completion
    ///     rule.
    ///   - type: Completion
    ///     Rule object type.
    ///   - variableType: Variable type
    ///     for the Completion
    ///     Rule object.
    public init(variableValue: CompletionRuleVariableVariableValueField, type: CompletionRuleVariableTypeField = CompletionRuleVariableTypeField.variable, variableType: CompletionRuleVariableVariableTypeField = CompletionRuleVariableVariableTypeField.taskCompletionRule) {
        self.variableValue = variableValue
        self.type = type
        self.variableType = variableType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        variableValue = try container.decode(CompletionRuleVariableVariableValueField.self, forKey: .variableValue)
        type = try container.decode(CompletionRuleVariableTypeField.self, forKey: .type)
        variableType = try container.decode(CompletionRuleVariableVariableTypeField.self, forKey: .variableType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(variableValue, forKey: .variableValue)
        try container.encode(type, forKey: .type)
        try container.encode(variableType, forKey: .variableType)
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
