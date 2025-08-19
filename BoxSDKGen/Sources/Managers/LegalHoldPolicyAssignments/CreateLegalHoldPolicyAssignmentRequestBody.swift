import Foundation

public class CreateLegalHoldPolicyAssignmentRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case policyId = "policy_id"
        case assignTo = "assign_to"
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

    /// Initializer for a CreateLegalHoldPolicyAssignmentRequestBody.
    ///
    /// - Parameters:
    ///   - policyId: The ID of the policy to assign.
    ///   - assignTo: The item to assign the policy to.
    public init(policyId: String, assignTo: CreateLegalHoldPolicyAssignmentRequestBodyAssignToField) {
        self.policyId = policyId
        self.assignTo = assignTo
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        policyId = try container.decode(String.self, forKey: .policyId)
        assignTo = try container.decode(CreateLegalHoldPolicyAssignmentRequestBodyAssignToField.self, forKey: .assignTo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(policyId, forKey: .policyId)
        try container.encode(assignTo, forKey: .assignTo)
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
