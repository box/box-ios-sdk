import Foundation

/// A verification method for a signer in a Sign Request Template.
/// This property can be used instead of the `login_required`, `is_phone_number_required` properties.
/// If this property is used, the `login_required` and `is_phone_number_required` properties will be ignored.
public enum TemplateSignerVerificationMethod: Codable {
    case templateSignerVerificationMethodLogin(TemplateSignerVerificationMethodLogin)
    case templateSignerVerificationMethodPhoneSms(TemplateSignerVerificationMethodPhoneSms)
    case templateSignerVerificationMethodCacPiv(TemplateSignerVerificationMethodCacPiv)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "login":
                    if let content = try? TemplateSignerVerificationMethodLogin(from: decoder) {
                        self = .templateSignerVerificationMethodLogin(content)
                        return
                    }

                case "phone":
                    if let content = try? TemplateSignerVerificationMethodPhoneSms(from: decoder) {
                        self = .templateSignerVerificationMethodPhoneSms(content)
                        return
                    }

                case "cac_piv":
                    if let content = try? TemplateSignerVerificationMethodCacPiv(from: decoder) {
                        self = .templateSignerVerificationMethodCacPiv(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(TemplateSignerVerificationMethod.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .templateSignerVerificationMethodLogin(let templateSignerVerificationMethodLogin):
            try templateSignerVerificationMethodLogin.encode(to: encoder)
        case .templateSignerVerificationMethodPhoneSms(let templateSignerVerificationMethodPhoneSms):
            try templateSignerVerificationMethodPhoneSms.encode(to: encoder)
        case .templateSignerVerificationMethodCacPiv(let templateSignerVerificationMethodCacPiv):
            try templateSignerVerificationMethodCacPiv.encode(to: encoder)
        }
    }

}
