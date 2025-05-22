import Foundation

public class CollaborationAcceptanceRequirementsStatusField: Codable {
    private enum CodingKeys: String, CodingKey {
        case termsOfServiceRequirement = "terms_of_service_requirement"
        case strongPasswordRequirement = "strong_password_requirement"
        case twoFactorAuthenticationRequirement = "two_factor_authentication_requirement"
    }

    public let termsOfServiceRequirement: CollaborationAcceptanceRequirementsStatusTermsOfServiceRequirementField?

    public let strongPasswordRequirement: CollaborationAcceptanceRequirementsStatusStrongPasswordRequirementField?

    public let twoFactorAuthenticationRequirement: CollaborationAcceptanceRequirementsStatusTwoFactorAuthenticationRequirementField?

    public init(termsOfServiceRequirement: CollaborationAcceptanceRequirementsStatusTermsOfServiceRequirementField? = nil, strongPasswordRequirement: CollaborationAcceptanceRequirementsStatusStrongPasswordRequirementField? = nil, twoFactorAuthenticationRequirement: CollaborationAcceptanceRequirementsStatusTwoFactorAuthenticationRequirementField? = nil) {
        self.termsOfServiceRequirement = termsOfServiceRequirement
        self.strongPasswordRequirement = strongPasswordRequirement
        self.twoFactorAuthenticationRequirement = twoFactorAuthenticationRequirement
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        termsOfServiceRequirement = try container.decodeIfPresent(CollaborationAcceptanceRequirementsStatusTermsOfServiceRequirementField.self, forKey: .termsOfServiceRequirement)
        strongPasswordRequirement = try container.decodeIfPresent(CollaborationAcceptanceRequirementsStatusStrongPasswordRequirementField.self, forKey: .strongPasswordRequirement)
        twoFactorAuthenticationRequirement = try container.decodeIfPresent(CollaborationAcceptanceRequirementsStatusTwoFactorAuthenticationRequirementField.self, forKey: .twoFactorAuthenticationRequirement)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(termsOfServiceRequirement, forKey: .termsOfServiceRequirement)
        try container.encodeIfPresent(strongPasswordRequirement, forKey: .strongPasswordRequirement)
        try container.encodeIfPresent(twoFactorAuthenticationRequirement, forKey: .twoFactorAuthenticationRequirement)
    }

}
