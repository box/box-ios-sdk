import Foundation

public class SignTemplateAdditionalInfoRequiredField: Codable {
    private enum CodingKeys: String, CodingKey {
        case signers
    }

    /// Required signer fields.
    public let signers: [[SignTemplateAdditionalInfoRequiredSignersField]]?

    /// Initializer for a SignTemplateAdditionalInfoRequiredField.
    ///
    /// - Parameters:
    ///   - signers: Required signer fields.
    public init(signers: [[SignTemplateAdditionalInfoRequiredSignersField]]? = nil) {
        self.signers = signers
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        signers = try container.decodeIfPresent([[SignTemplateAdditionalInfoRequiredSignersField]].self, forKey: .signers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(signers, forKey: .signers)
    }

}
