import Foundation

/// Metadata describing a file uploaded by a signer as an attachment.
public class SignRequestSignerAttachment: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Identifier of the attachment file.
    @CodableTriState public private(set) var id: String?

    /// Display name of the attachment file.
    @CodableTriState public private(set) var name: String?

    /// Initializer for a SignRequestSignerAttachment.
    ///
    /// - Parameters:
    ///   - id: Identifier of the attachment file.
    ///   - name: Display name of the attachment file.
    public init(id: TriStateField<String> = nil, name: TriStateField<String> = nil) {
        self._id = CodableTriState(state: id)
        self._name = CodableTriState(state: name)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _id.state, forKey: .id)
        try container.encode(field: _name.state, forKey: .name)
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
