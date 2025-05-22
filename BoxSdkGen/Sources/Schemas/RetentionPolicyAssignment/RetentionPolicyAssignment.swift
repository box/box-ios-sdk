import Foundation

/// A retention assignment represents a rule specifying
/// the files a retention policy retains.
/// Assignments can retain files based on their folder or metadata,
/// or hold all files in the enterprise.
public class RetentionPolicyAssignment: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case retentionPolicy = "retention_policy"
        case assignedTo = "assigned_to"
        case filterFields = "filter_fields"
        case assignedBy = "assigned_by"
        case assignedAt = "assigned_at"
        case startDateField = "start_date_field"
    }

    /// The unique identifier for a retention policy assignment.
    public let id: String

    /// `retention_policy_assignment`
    public let type: RetentionPolicyAssignmentTypeField

    public let retentionPolicy: RetentionPolicyMini?

    /// The `type` and `id` of the content that is under
    /// retention. The `type` can either be `folder`
    /// `enterprise`, or `metadata_template`.
    public let assignedTo: RetentionPolicyAssignmentAssignedToField?

    /// An array of field objects. Values are only returned if the `assigned_to`
    /// type is `metadata_template`. Otherwise, the array is blank.
    @CodableTriState public private(set) var filterFields: [RetentionPolicyAssignmentFilterFieldsField]?

    public let assignedBy: UserMini?

    /// When the retention policy assignment object was
    /// created.
    public let assignedAt: Date?

    /// The date the retention policy assignment begins.
    /// If the `assigned_to` type is `metadata_template`,
    /// this field can be a date field's metadata attribute key id.
    public let startDateField: String?

    /// Initializer for a RetentionPolicyAssignment.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for a retention policy assignment.
    ///   - type: `retention_policy_assignment`
    ///   - retentionPolicy: 
    ///   - assignedTo: The `type` and `id` of the content that is under
    ///     retention. The `type` can either be `folder`
    ///     `enterprise`, or `metadata_template`.
    ///   - filterFields: An array of field objects. Values are only returned if the `assigned_to`
    ///     type is `metadata_template`. Otherwise, the array is blank.
    ///   - assignedBy: 
    ///   - assignedAt: When the retention policy assignment object was
    ///     created.
    ///   - startDateField: The date the retention policy assignment begins.
    ///     If the `assigned_to` type is `metadata_template`,
    ///     this field can be a date field's metadata attribute key id.
    public init(id: String, type: RetentionPolicyAssignmentTypeField = RetentionPolicyAssignmentTypeField.retentionPolicyAssignment, retentionPolicy: RetentionPolicyMini? = nil, assignedTo: RetentionPolicyAssignmentAssignedToField? = nil, filterFields: TriStateField<[RetentionPolicyAssignmentFilterFieldsField]> = nil, assignedBy: UserMini? = nil, assignedAt: Date? = nil, startDateField: String? = nil) {
        self.id = id
        self.type = type
        self.retentionPolicy = retentionPolicy
        self.assignedTo = assignedTo
        self._filterFields = CodableTriState(state: filterFields)
        self.assignedBy = assignedBy
        self.assignedAt = assignedAt
        self.startDateField = startDateField
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(RetentionPolicyAssignmentTypeField.self, forKey: .type)
        retentionPolicy = try container.decodeIfPresent(RetentionPolicyMini.self, forKey: .retentionPolicy)
        assignedTo = try container.decodeIfPresent(RetentionPolicyAssignmentAssignedToField.self, forKey: .assignedTo)
        filterFields = try container.decodeIfPresent([RetentionPolicyAssignmentFilterFieldsField].self, forKey: .filterFields)
        assignedBy = try container.decodeIfPresent(UserMini.self, forKey: .assignedBy)
        assignedAt = try container.decodeDateTimeIfPresent(forKey: .assignedAt)
        startDateField = try container.decodeIfPresent(String.self, forKey: .startDateField)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(retentionPolicy, forKey: .retentionPolicy)
        try container.encodeIfPresent(assignedTo, forKey: .assignedTo)
        try container.encode(field: _filterFields.state, forKey: .filterFields)
        try container.encodeIfPresent(assignedBy, forKey: .assignedBy)
        try container.encodeDateTimeIfPresent(field: assignedAt, forKey: .assignedAt)
        try container.encodeIfPresent(startDateField, forKey: .startDateField)
    }

}
