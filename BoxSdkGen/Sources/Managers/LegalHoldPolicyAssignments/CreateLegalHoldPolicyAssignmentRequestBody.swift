import Foundation

public class CreateLegalHoldPolicyAssignmentRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case policyId = "policy_id"
        case assignTo = "assign_to"
        case filterFields = "filter_fields"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The ID of the policy to assign.
    public let policyId: String

    /// The item to assign the policy to.
    public let assignTo: CreateLegalHoldPolicyAssignmentRequestBodyAssignToField

    /// List of metadata template field filters. Only required when `assign_to.type` is `metadata_template`.
    public let filterFields: [LegalHoldPolicyAssignmentFilterField]?

    /// Initializer for a CreateLegalHoldPolicyAssignmentRequestBody.
    ///
    /// - Parameters:
    ///   - policyId: The ID of the policy to assign.
    ///   - assignTo: The item to assign the policy to.
    ///   - filterFields: List of metadata template field filters. Only required when `assign_to.type` is `metadata_template`.
    public init(policyId: String, assignTo: CreateLegalHoldPolicyAssignmentRequestBodyAssignToField, filterFields: [LegalHoldPolicyAssignmentFilterField]? = nil) {
        self.policyId = policyId
        self.assignTo = assignTo
        self.filterFields = filterFields
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        policyId = try container.decode(String.self, forKey: .policyId)
        assignTo = try container.decode(CreateLegalHoldPolicyAssignmentRequestBodyAssignToField.self, forKey: .assignTo)
        filterFields = try container.decodeIfPresent([LegalHoldPolicyAssignmentFilterField].self, forKey: .filterFields)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(policyId, forKey: .policyId)
        try container.encode(assignTo, forKey: .assignTo)
        try container.encodeIfPresent(filterFields, forKey: .filterFields)
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
