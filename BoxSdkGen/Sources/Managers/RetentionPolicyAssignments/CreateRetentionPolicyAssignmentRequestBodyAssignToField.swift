import Foundation

public class CreateRetentionPolicyAssignmentRequestBodyAssignToField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// The type of item to assign the policy to.
    public let type: CreateRetentionPolicyAssignmentRequestBodyAssignToTypeField

    /// The ID of item to assign the policy to.
    /// Set to `null` or omit when `type` is set to
    /// `enterprise`.
    @CodableTriState public private(set) var id: String?

    /// Initializer for a CreateRetentionPolicyAssignmentRequestBodyAssignToField.
    ///
    /// - Parameters:
    ///   - type: The type of item to assign the policy to.
    ///   - id: The ID of item to assign the policy to.
    ///     Set to `null` or omit when `type` is set to
    ///     `enterprise`.
    public init(type: CreateRetentionPolicyAssignmentRequestBodyAssignToTypeField, id: TriStateField<String> = nil) {
        self.type = type
        self._id = CodableTriState(state: id)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(CreateRetentionPolicyAssignmentRequestBodyAssignToTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(field: _id.state, forKey: .id)
    }

}
