import Foundation

/// A user tracking code.
public class UserTrackingCodeV2025R0: Codable, RawJSONReadable {
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


    /// The ID of the user tracking code.
    @CodableTriState public private(set) var id: Int64?

    /// The name of the user tracking code.
    @CodableTriState public private(set) var name: String?

    /// Initializer for a UserTrackingCodeV2025R0.
    ///
    /// - Parameters:
    ///   - id: The ID of the user tracking code.
    ///   - name: The name of the user tracking code.
    public init(id: TriStateField<Int64> = nil, name: TriStateField<String> = nil) {
        self._id = CodableTriState(state: id)
        self._name = CodableTriState(state: name)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int64.self, forKey: .id)
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
