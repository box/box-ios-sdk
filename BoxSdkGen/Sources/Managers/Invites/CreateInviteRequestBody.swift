import Foundation

public class CreateInviteRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case enterprise
        case actionableBy = "actionable_by"
    }

    /// The enterprise to invite the user to
    public let enterprise: CreateInviteRequestBodyEnterpriseField

    /// The user to invite
    public let actionableBy: CreateInviteRequestBodyActionableByField

    /// Initializer for a CreateInviteRequestBody.
    ///
    /// - Parameters:
    ///   - enterprise: The enterprise to invite the user to
    ///   - actionableBy: The user to invite
    public init(enterprise: CreateInviteRequestBodyEnterpriseField, actionableBy: CreateInviteRequestBodyActionableByField) {
        self.enterprise = enterprise
        self.actionableBy = actionableBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enterprise = try container.decode(CreateInviteRequestBodyEnterpriseField.self, forKey: .enterprise)
        actionableBy = try container.decode(CreateInviteRequestBodyActionableByField.self, forKey: .actionableBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enterprise, forKey: .enterprise)
        try container.encode(actionableBy, forKey: .actionableBy)
    }

}
