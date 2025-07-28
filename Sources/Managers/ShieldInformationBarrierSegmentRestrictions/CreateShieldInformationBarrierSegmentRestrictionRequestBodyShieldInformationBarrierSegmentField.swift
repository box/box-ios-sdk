import Foundation

public class CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The ID reference of the requesting
    /// shield information barrier segment.
    public let id: String?

    /// The type of the shield barrier segment for this member.
    public let type: CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentTypeField?

    /// Initializer for a CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentField.
    ///
    /// - Parameters:
    ///   - id: The ID reference of the requesting
    ///     shield information barrier segment.
    ///   - type: The type of the shield barrier segment for this member.
    public init(id: String? = nil, type: CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
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
