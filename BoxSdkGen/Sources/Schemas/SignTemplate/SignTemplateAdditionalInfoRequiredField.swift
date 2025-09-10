import Foundation

public class SignTemplateAdditionalInfoRequiredField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case signers
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
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
