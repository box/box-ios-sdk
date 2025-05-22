import Foundation

public class TrashWebLinkPathCollectionEntriesField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case sequenceId = "sequence_id"
        case etag
        case name
    }

    /// `folder`
    public let type: TrashWebLinkPathCollectionEntriesTypeField?

    /// The unique identifier that represent a folder.
    public let id: String?

    /// This field is null for the Trash folder
    @CodableTriState public private(set) var sequenceId: String?

    /// This field is null for the Trash folder
    @CodableTriState public private(set) var etag: String?

    /// The name of the Trash folder.
    public let name: String?

    /// Initializer for a TrashWebLinkPathCollectionEntriesField.
    ///
    /// - Parameters:
    ///   - type: `folder`
    ///   - id: The unique identifier that represent a folder.
    ///   - sequenceId: This field is null for the Trash folder
    ///   - etag: This field is null for the Trash folder
    ///   - name: The name of the Trash folder.
    public init(type: TrashWebLinkPathCollectionEntriesTypeField? = nil, id: String? = nil, sequenceId: TriStateField<String> = nil, etag: TriStateField<String> = nil, name: String? = nil) {
        self.type = type
        self.id = id
        self._sequenceId = CodableTriState(state: sequenceId)
        self._etag = CodableTriState(state: etag)
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(TrashWebLinkPathCollectionEntriesTypeField.self, forKey: .type)
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

}
