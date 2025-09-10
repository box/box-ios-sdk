import Foundation

public class UpdateShieldInformationBarrierSegmentByIdRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case name
        case description
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The updated name for the shield information barrier segment.
    public let name: String?

    /// The updated description for
    /// the shield information barrier segment.
    @CodableTriState public private(set) var description: String?

    /// Initializer for a UpdateShieldInformationBarrierSegmentByIdRequestBody.
    ///
    /// - Parameters:
    ///   - name: The updated name for the shield information barrier segment.
    ///   - description: The updated description for
    ///     the shield information barrier segment.
    public init(name: String? = nil, description: TriStateField<String> = nil) {
        self.name = name
        self._description = CodableTriState(state: description)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(field: _description.state, forKey: .description)
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
