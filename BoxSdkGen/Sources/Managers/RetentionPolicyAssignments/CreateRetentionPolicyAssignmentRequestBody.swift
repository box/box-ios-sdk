import Foundation

public class CreateRetentionPolicyAssignmentRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case policyId = "policy_id"
        case assignTo = "assign_to"
        case filterFields = "filter_fields"
        case startDateField = "start_date_field"
    }

    /// The ID of the retention policy to assign
    public let policyId: String

    /// The item to assign the policy to
    public let assignTo: CreateRetentionPolicyAssignmentRequestBodyAssignToField

    /// If the `assign_to` type is `metadata_template`,
    /// then optionally add the `filter_fields` parameter which will
    /// require an array of objects with a field entry and a value entry.
    /// Currently only one object of `field` and `value` is supported.
    public let filterFields: [CreateRetentionPolicyAssignmentRequestBodyFilterFieldsField]?

    /// The date the retention policy assignment begins.
    /// 
    /// If the `assigned_to` type is `metadata_template`,
    /// this field can be a date field's metadata attribute key id.
    public let startDateField: String?

    /// Initializer for a CreateRetentionPolicyAssignmentRequestBody.
    ///
    /// - Parameters:
    ///   - policyId: The ID of the retention policy to assign
    ///   - assignTo: The item to assign the policy to
    ///   - filterFields: If the `assign_to` type is `metadata_template`,
    ///     then optionally add the `filter_fields` parameter which will
    ///     require an array of objects with a field entry and a value entry.
    ///     Currently only one object of `field` and `value` is supported.
    ///   - startDateField: The date the retention policy assignment begins.
    ///     
    ///     If the `assigned_to` type is `metadata_template`,
    ///     this field can be a date field's metadata attribute key id.
    public init(policyId: String, assignTo: CreateRetentionPolicyAssignmentRequestBodyAssignToField, filterFields: [CreateRetentionPolicyAssignmentRequestBodyFilterFieldsField]? = nil, startDateField: String? = nil) {
        self.policyId = policyId
        self.assignTo = assignTo
        self.filterFields = filterFields
        self.startDateField = startDateField
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        policyId = try container.decode(String.self, forKey: .policyId)
        assignTo = try container.decode(CreateRetentionPolicyAssignmentRequestBodyAssignToField.self, forKey: .assignTo)
        filterFields = try container.decodeIfPresent([CreateRetentionPolicyAssignmentRequestBodyFilterFieldsField].self, forKey: .filterFields)
        startDateField = try container.decodeIfPresent(String.self, forKey: .startDateField)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(policyId, forKey: .policyId)
        try container.encode(assignTo, forKey: .assignTo)
        try container.encodeIfPresent(filterFields, forKey: .filterFields)
        try container.encodeIfPresent(startDateField, forKey: .startDateField)
    }

}
