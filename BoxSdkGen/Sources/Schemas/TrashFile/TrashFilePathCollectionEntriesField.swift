import Foundation

public class TrashFilePathCollectionEntriesField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case sequenceId = "sequence_id"
        case etag
        case name
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The value will always be `folder`.
    public let type: TrashFilePathCollectionEntriesTypeField?

    /// The unique identifier that represent a folder.
    public let id: String?

    /// This field is null for the Trash folder.
    @CodableTriState public private(set) var sequenceId: String?

    /// This field is null for the Trash folder.
    @CodableTriState public private(set) var etag: String?

    /// The name of the Trash folder.
    public let name: String?

    /// Initializer for a TrashFilePathCollectionEntriesField.
    ///
    /// - Parameters:
    ///   - type: The value will always be `folder`.
    ///   - id: The unique identifier that represent a folder.
    ///   - sequenceId: This field is null for the Trash folder.
    ///   - etag: This field is null for the Trash folder.
    ///   - name: The name of the Trash folder.
    public init(type: TrashFilePathCollectionEntriesTypeField? = nil, id: String? = nil, sequenceId: TriStateField<String> = nil, etag: TriStateField<String> = nil, name: String? = nil) {
        self.type = type
        self.id = id
        self._sequenceId = CodableTriState(state: sequenceId)
        self._etag = CodableTriState(state: etag)
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(TrashFilePathCollectionEntriesTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        sequenceId = try container.decodeIfPresent(String.self, forKey: .sequenceId)
        etag = try container.decodeIfPresent(String.self, forKey: .etag)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(field: _sequenceId.state, forKey: .sequenceId)
        try container.encode(field: _etag.state, forKey: .etag)
        try container.encodeIfPresent(name, forKey: .name)
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
