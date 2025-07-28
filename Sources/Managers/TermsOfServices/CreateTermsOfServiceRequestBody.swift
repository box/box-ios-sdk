import Foundation

public class CreateTermsOfServiceRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case status
        case text
        case tosType = "tos_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether this terms of service is active.
    public let status: CreateTermsOfServiceRequestBodyStatusField

    /// The terms of service text to display to users.
    /// 
    /// The text can be set to empty if the `status` is set to `disabled`.
    public let text: String

    /// The type of user to set the terms of
    /// service for.
    public let tosType: CreateTermsOfServiceRequestBodyTosTypeField?

    /// Initializer for a CreateTermsOfServiceRequestBody.
    ///
    /// - Parameters:
    ///   - status: Whether this terms of service is active.
    ///   - text: The terms of service text to display to users.
    ///     
    ///     The text can be set to empty if the `status` is set to `disabled`.
    ///   - tosType: The type of user to set the terms of
    ///     service for.
    public init(status: CreateTermsOfServiceRequestBodyStatusField, text: String, tosType: CreateTermsOfServiceRequestBodyTosTypeField? = nil) {
        self.status = status
        self.text = text
        self.tosType = tosType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(CreateTermsOfServiceRequestBodyStatusField.self, forKey: .status)
        text = try container.decode(String.self, forKey: .text)
        tosType = try container.decodeIfPresent(CreateTermsOfServiceRequestBodyTosTypeField.self, forKey: .tosType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(tosType, forKey: .tosType)
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
