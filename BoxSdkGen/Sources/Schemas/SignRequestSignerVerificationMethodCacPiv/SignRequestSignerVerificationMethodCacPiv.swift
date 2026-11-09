import Foundation

/// The verification method to be used when user has to verify themselves using a CAC/PIV smart-card.
public class SignRequestSignerVerificationMethodCacPiv: Codable, RawJSONReadable {
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
    public let type: SignRequestSignerVerificationMethodCacPivTypeField

    /// Initializer for a SignRequestSignerVerificationMethodCacPiv.
    ///
    /// - Parameters:
    ///   - type: The type of verification method.
    public init(type: SignRequestSignerVerificationMethodCacPivTypeField = SignRequestSignerVerificationMethodCacPivTypeField.cacPiv) {
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(SignRequestSignerVerificationMethodCacPivTypeField.self, forKey: .type)
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
