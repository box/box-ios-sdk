import Foundation

/// When used as a verification method the signer will need to 
/// log in to a Box account before signing the request. If the 
/// signer does not have an existing account, they will have the 
/// option to create a free Box account.
public class TemplateSignerVerificationMethodLogin: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of verification method.
    public let type: TemplateSignerVerificationMethodLoginTypeField

    /// Initializer for a TemplateSignerVerificationMethodLogin.
    ///
    /// - Parameters:
    ///   - type: The type of verification method.
    public init(type: TemplateSignerVerificationMethodLoginTypeField = TemplateSignerVerificationMethodLoginTypeField.login) {
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(TemplateSignerVerificationMethodLoginTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
