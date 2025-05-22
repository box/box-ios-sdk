import Foundation

public class CollaborationAcceptanceRequirementsStatusTermsOfServiceRequirementField: Codable {
    private enum CodingKeys: String, CodingKey {
        case isAccepted = "is_accepted"
        case termsOfService = "terms_of_service"
    }

    /// Whether or not the terms of service have been accepted.  The
    /// field is `null` when there is no terms of service required.
    @CodableTriState public private(set) var isAccepted: Bool?

    public let termsOfService: TermsOfServiceBase?

    /// Initializer for a CollaborationAcceptanceRequirementsStatusTermsOfServiceRequirementField.
    ///
    /// - Parameters:
    ///   - isAccepted: Whether or not the terms of service have been accepted.  The
    ///     field is `null` when there is no terms of service required.
    ///   - termsOfService: 
    public init(isAccepted: TriStateField<Bool> = nil, termsOfService: TermsOfServiceBase? = nil) {
        self._isAccepted = CodableTriState(state: isAccepted)
        self.termsOfService = termsOfService
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isAccepted = try container.decodeIfPresent(Bool.self, forKey: .isAccepted)
        termsOfService = try container.decodeIfPresent(TermsOfServiceBase.self, forKey: .termsOfService)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _isAccepted.state, forKey: .isAccepted)
        try container.encodeIfPresent(termsOfService, forKey: .termsOfService)
    }

}
