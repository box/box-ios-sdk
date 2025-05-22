import Foundation

public class SignRequestSignerSignerDecisionField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case finalizedAt = "finalized_at"
        case additionalInfo = "additional_info"
    }

    /// Type of decision made by the signer.
    public let type: SignRequestSignerSignerDecisionTypeField?

    /// Date and Time that the decision was made.
    public let finalizedAt: Date?

    /// Additional info about the decision, such as the decline reason from the signer.
    @CodableTriState public private(set) var additionalInfo: String?

    /// Initializer for a SignRequestSignerSignerDecisionField.
    ///
    /// - Parameters:
    ///   - type: Type of decision made by the signer.
    ///   - finalizedAt: Date and Time that the decision was made.
    ///   - additionalInfo: Additional info about the decision, such as the decline reason from the signer.
    public init(type: SignRequestSignerSignerDecisionTypeField? = nil, finalizedAt: Date? = nil, additionalInfo: TriStateField<String> = nil) {
        self.type = type
        self.finalizedAt = finalizedAt
        self._additionalInfo = CodableTriState(state: additionalInfo)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(SignRequestSignerSignerDecisionTypeField.self, forKey: .type)
        finalizedAt = try container.decodeDateTimeIfPresent(forKey: .finalizedAt)
        additionalInfo = try container.decodeIfPresent(String.self, forKey: .additionalInfo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeDateTimeIfPresent(field: finalizedAt, forKey: .finalizedAt)
        try container.encode(field: _additionalInfo.state, forKey: .additionalInfo)
    }

}
