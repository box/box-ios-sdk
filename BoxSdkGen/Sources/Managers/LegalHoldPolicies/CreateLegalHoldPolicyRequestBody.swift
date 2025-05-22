import Foundation

public class CreateLegalHoldPolicyRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case policyName = "policy_name"
        case description
        case filterStartedAt = "filter_started_at"
        case filterEndedAt = "filter_ended_at"
        case isOngoing = "is_ongoing"
    }

    /// The name of the policy.
    public let policyName: String

    /// A description for the policy.
    public let description: String?

    /// The filter start date.
    /// 
    /// When this policy is applied using a `custodian` legal
    /// hold assignments, it will only apply to file versions
    /// created or uploaded inside of the
    /// date range. Other assignment types, such as folders and
    /// files, will ignore the date filter.
    /// 
    /// Required if `is_ongoing` is set to `false`.
    public let filterStartedAt: Date?

    /// The filter end date.
    /// 
    /// When this policy is applied using a `custodian` legal
    /// hold assignments, it will only apply to file versions
    /// created or uploaded inside of the
    /// date range. Other assignment types, such as folders and
    /// files, will ignore the date filter.
    /// 
    /// Required if `is_ongoing` is set to `false`.
    public let filterEndedAt: Date?

    /// Whether new assignments under this policy should
    /// continue applying to files even after initialization.
    /// 
    /// When this policy is applied using a legal hold assignment,
    /// it will continue applying the policy to any new file versions
    /// even after it has been applied.
    /// 
    /// For example, if a legal hold assignment is placed on a user
    /// today, and that user uploads a file tomorrow, that file will
    /// get held. This will continue until the policy is retired.
    /// 
    /// Required if no filter dates are set.
    public let isOngoing: Bool?

    /// Initializer for a CreateLegalHoldPolicyRequestBody.
    ///
    /// - Parameters:
    ///   - policyName: The name of the policy.
    ///   - description: A description for the policy.
    ///   - filterStartedAt: The filter start date.
    ///     
    ///     When this policy is applied using a `custodian` legal
    ///     hold assignments, it will only apply to file versions
    ///     created or uploaded inside of the
    ///     date range. Other assignment types, such as folders and
    ///     files, will ignore the date filter.
    ///     
    ///     Required if `is_ongoing` is set to `false`.
    ///   - filterEndedAt: The filter end date.
    ///     
    ///     When this policy is applied using a `custodian` legal
    ///     hold assignments, it will only apply to file versions
    ///     created or uploaded inside of the
    ///     date range. Other assignment types, such as folders and
    ///     files, will ignore the date filter.
    ///     
    ///     Required if `is_ongoing` is set to `false`.
    ///   - isOngoing: Whether new assignments under this policy should
    ///     continue applying to files even after initialization.
    ///     
    ///     When this policy is applied using a legal hold assignment,
    ///     it will continue applying the policy to any new file versions
    ///     even after it has been applied.
    ///     
    ///     For example, if a legal hold assignment is placed on a user
    ///     today, and that user uploads a file tomorrow, that file will
    ///     get held. This will continue until the policy is retired.
    ///     
    ///     Required if no filter dates are set.
    public init(policyName: String, description: String? = nil, filterStartedAt: Date? = nil, filterEndedAt: Date? = nil, isOngoing: Bool? = nil) {
        self.policyName = policyName
        self.description = description
        self.filterStartedAt = filterStartedAt
        self.filterEndedAt = filterEndedAt
        self.isOngoing = isOngoing
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        policyName = try container.decode(String.self, forKey: .policyName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        filterStartedAt = try container.decodeDateTimeIfPresent(forKey: .filterStartedAt)
        filterEndedAt = try container.decodeDateTimeIfPresent(forKey: .filterEndedAt)
        isOngoing = try container.decodeIfPresent(Bool.self, forKey: .isOngoing)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(policyName, forKey: .policyName)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeDateTimeIfPresent(field: filterStartedAt, forKey: .filterStartedAt)
        try container.encodeDateTimeIfPresent(field: filterEndedAt, forKey: .filterEndedAt)
        try container.encodeIfPresent(isOngoing, forKey: .isOngoing)
    }

}
