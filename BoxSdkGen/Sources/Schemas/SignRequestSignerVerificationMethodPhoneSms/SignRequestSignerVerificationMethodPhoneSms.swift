import Foundation

/// When used as a verification method, prior to signing the document, 
/// the signer will have to verify themselves using two-factor 
/// authentication by receiving an SMS message on their phone.
public class SignRequestSignerVerificationMethodPhoneSms: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The phone number to where the message will be sent.
    public let phoneNumber: String

    /// The type of verification method.
    public let type: SignRequestSignerVerificationMethodPhoneSmsTypeField

    /// Initializer for a SignRequestSignerVerificationMethodPhoneSms.
    ///
    /// - Parameters:
    ///   - phoneNumber: The phone number to where the message will be sent.
    ///   - type: The type of verification method.
    public init(phoneNumber: String, type: SignRequestSignerVerificationMethodPhoneSmsTypeField = SignRequestSignerVerificationMethodPhoneSmsTypeField.phone) {
        self.phoneNumber = phoneNumber
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        type = try container.decode(SignRequestSignerVerificationMethodPhoneSmsTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(type, forKey: .type)
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
