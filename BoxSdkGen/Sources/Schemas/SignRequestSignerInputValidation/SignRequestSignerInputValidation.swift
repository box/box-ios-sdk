import Foundation

/// Specifies the formatting rules that signers must follow for text field inputs.
/// If set, this validation is mandatory. 
/// The format can be selected from a predefined list of options (e.g., email, phone number, date) or
/// defined using a custom regular expression.
public enum SignRequestSignerInputValidation: Codable {
    case signRequestSignerInputCustomValidation(SignRequestSignerInputCustomValidation)
    case signRequestSignerInputDateAsiaValidation(SignRequestSignerInputDateAsiaValidation)
    case signRequestSignerInputDateEuValidation(SignRequestSignerInputDateEuValidation)
    case signRequestSignerInputDateIsoValidation(SignRequestSignerInputDateIsoValidation)
    case signRequestSignerInputDateUsValidation(SignRequestSignerInputDateUsValidation)
    case signRequestSignerInputEmailValidation(SignRequestSignerInputEmailValidation)
    case signRequestSignerInputNumberWithCommaValidation(SignRequestSignerInputNumberWithCommaValidation)
    case signRequestSignerInputNumberWithPeriodValidation(SignRequestSignerInputNumberWithPeriodValidation)
    case signRequestSignerInputSsnValidation(SignRequestSignerInputSsnValidation)
    case signRequestSignerInputZip4Validation(SignRequestSignerInputZip4Validation)
    case signRequestSignerInputZipValidation(SignRequestSignerInputZipValidation)

    public init(from decoder: Decoder) throws {
        if let content = try? SignRequestSignerInputCustomValidation(from: decoder) {
            self = .signRequestSignerInputCustomValidation(content)
            return
        }

        if let content = try? SignRequestSignerInputDateAsiaValidation(from: decoder) {
            self = .signRequestSignerInputDateAsiaValidation(content)
            return
        }

        if let content = try? SignRequestSignerInputDateEuValidation(from: decoder) {
            self = .signRequestSignerInputDateEuValidation(content)
            return
        }

        if let content = try? SignRequestSignerInputDateIsoValidation(from: decoder) {
            self = .signRequestSignerInputDateIsoValidation(content)
            return
        }

        if let content = try? SignRequestSignerInputDateUsValidation(from: decoder) {
            self = .signRequestSignerInputDateUsValidation(content)
            return
        }

        if let content = try? SignRequestSignerInputEmailValidation(from: decoder) {
            self = .signRequestSignerInputEmailValidation(content)
            return
        }

        if let content = try? SignRequestSignerInputNumberWithCommaValidation(from: decoder) {
            self = .signRequestSignerInputNumberWithCommaValidation(content)
            return
        }

        if let content = try? SignRequestSignerInputNumberWithPeriodValidation(from: decoder) {
            self = .signRequestSignerInputNumberWithPeriodValidation(content)
            return
        }

        if let content = try? SignRequestSignerInputSsnValidation(from: decoder) {
            self = .signRequestSignerInputSsnValidation(content)
            return
        }

        if let content = try? SignRequestSignerInputZip4Validation(from: decoder) {
            self = .signRequestSignerInputZip4Validation(content)
            return
        }

        if let content = try? SignRequestSignerInputZipValidation(from: decoder) {
            self = .signRequestSignerInputZipValidation(content)
            return
        }

        throw DecodingError.typeMismatch(SignRequestSignerInputValidation.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .signRequestSignerInputCustomValidation(let signRequestSignerInputCustomValidation):
            try signRequestSignerInputCustomValidation.encode(to: encoder)
        case .signRequestSignerInputDateAsiaValidation(let signRequestSignerInputDateAsiaValidation):
            try signRequestSignerInputDateAsiaValidation.encode(to: encoder)
        case .signRequestSignerInputDateEuValidation(let signRequestSignerInputDateEuValidation):
            try signRequestSignerInputDateEuValidation.encode(to: encoder)
        case .signRequestSignerInputDateIsoValidation(let signRequestSignerInputDateIsoValidation):
            try signRequestSignerInputDateIsoValidation.encode(to: encoder)
        case .signRequestSignerInputDateUsValidation(let signRequestSignerInputDateUsValidation):
            try signRequestSignerInputDateUsValidation.encode(to: encoder)
        case .signRequestSignerInputEmailValidation(let signRequestSignerInputEmailValidation):
            try signRequestSignerInputEmailValidation.encode(to: encoder)
        case .signRequestSignerInputNumberWithCommaValidation(let signRequestSignerInputNumberWithCommaValidation):
            try signRequestSignerInputNumberWithCommaValidation.encode(to: encoder)
        case .signRequestSignerInputNumberWithPeriodValidation(let signRequestSignerInputNumberWithPeriodValidation):
            try signRequestSignerInputNumberWithPeriodValidation.encode(to: encoder)
        case .signRequestSignerInputSsnValidation(let signRequestSignerInputSsnValidation):
            try signRequestSignerInputSsnValidation.encode(to: encoder)
        case .signRequestSignerInputZip4Validation(let signRequestSignerInputZip4Validation):
            try signRequestSignerInputZip4Validation.encode(to: encoder)
        case .signRequestSignerInputZipValidation(let signRequestSignerInputZipValidation):
            try signRequestSignerInputZipValidation.encode(to: encoder)
        }
    }

}
