import Foundation

/// A verification method for a signer in a Sign Request. 
/// This property can be used instead of the `login_required` and `verification_phone_number` properties.
/// If this property is used, the `login_required` and `verification_phone_number` properties will be ignored.
public enum SignRequestSignerVerificationMethod: Codable {
    case signRequestSignerVerificationMethodLogin(SignRequestSignerVerificationMethodLogin)
    case signRequestSignerVerificationMethodPhoneSms(SignRequestSignerVerificationMethodPhoneSms)
    case signRequestSignerVerificationMethodCacPiv(SignRequestSignerVerificationMethodCacPiv)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "login":
                    if let content = try? SignRequestSignerVerificationMethodLogin(from: decoder) {
                        self = .signRequestSignerVerificationMethodLogin(content)
                        return
                    }

                case "phone":
                    if let content = try? SignRequestSignerVerificationMethodPhoneSms(from: decoder) {
                        self = .signRequestSignerVerificationMethodPhoneSms(content)
                        return
                    }

                case "cac_piv":
                    if let content = try? SignRequestSignerVerificationMethodCacPiv(from: decoder) {
                        self = .signRequestSignerVerificationMethodCacPiv(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(SignRequestSignerVerificationMethod.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .signRequestSignerVerificationMethodLogin(let signRequestSignerVerificationMethodLogin):
            try signRequestSignerVerificationMethodLogin.encode(to: encoder)
        case .signRequestSignerVerificationMethodPhoneSms(let signRequestSignerVerificationMethodPhoneSms):
            try signRequestSignerVerificationMethodPhoneSms.encode(to: encoder)
        case .signRequestSignerVerificationMethodCacPiv(let signRequestSignerVerificationMethodCacPiv):
            try signRequestSignerVerificationMethodCacPiv.encode(to: encoder)
        }
    }

}
