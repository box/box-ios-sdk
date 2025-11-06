import Foundation

/// An archive is a folder dedicated to storing content that is
/// redundant, outdated, or trivial. Content in an archive is not accessible to its
/// owner and collaborators.
/// To use this feature, you must request GCM scope for your Box application.
public class ArchiveV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case size
        case type
        case description
        case ownedBy = "owned_by"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier that represents an archive.
    public let id: String

    /// The name of the archive.
    /// 
    /// The following restrictions to the archive name apply: names containing
    /// non-printable ASCII characters, forward and backward slashes
    /// (`/`, `\`), names with trailing spaces, and names `.` and `..` are
    /// not allowed.
    public let name: String

    /// The size of the archive in bytes.
    public let size: Int64

    /// The value is always `archive`.
    public let type: ArchiveV2025R0TypeField

    /// The description of the archive.
    @CodableTriState public private(set) var description: String?

    /// The part of an archive API response that describes the user who owns the archive.
    public let ownedBy: ArchiveV2025R0OwnedByField?

    /// Initializer for a ArchiveV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represents an archive.
    ///   - name: The name of the archive.
    ///     
    ///     The following restrictions to the archive name apply: names containing
    ///     non-printable ASCII characters, forward and backward slashes
    ///     (`/`, `\`), names with trailing spaces, and names `.` and `..` are
    ///     not allowed.
    ///   - size: The size of the archive in bytes.
    ///   - type: The value is always `archive`.
    ///   - description: The description of the archive.
    ///   - ownedBy: The part of an archive API response that describes the user who owns the archive.
    public init(id: String, name: String, size: Int64, type: ArchiveV2025R0TypeField = ArchiveV2025R0TypeField.archive, description: TriStateField<String> = nil, ownedBy: ArchiveV2025R0OwnedByField? = nil) {
        self.id = id
        self.name = name
        self.size = size
        self.type = type
        self._description = CodableTriState(state: description)
        self.ownedBy = ownedBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        size = try container.decode(Int64.self, forKey: .size)
        type = try container.decode(ArchiveV2025R0TypeField.self, forKey: .type)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        ownedBy = try container.decodeIfPresent(ArchiveV2025R0OwnedByField.self, forKey: .ownedBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(size, forKey: .size)
        try container.encode(type, forKey: .type)
        try container.encode(field: _description.state, forKey: .description)
        try container.encodeIfPresent(ownedBy, forKey: .ownedBy)
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
