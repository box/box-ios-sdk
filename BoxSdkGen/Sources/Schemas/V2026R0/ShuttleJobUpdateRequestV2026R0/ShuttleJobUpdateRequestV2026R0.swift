import Foundation

/// The request body used to update an existing shuttle job. Only the fields
/// supplied in the request body are changed.
public class ShuttleJobUpdateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case name
        case comment
        case tags
        case accountMapping = "account_mapping"
        case settings
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The human-readable name of the shuttle job.
    public let name: String?

    /// An optional free-form comment describing the shuttle job.
    @CodableTriState public private(set) var comment: String?

    /// A list of free-form tags associated with the shuttle job.
    public let tags: [String]?

    /// The account mapping configuration that controls how source identities
    /// and permissions are translated into Box.
    public let accountMapping: ShuttleJobUpdateRequestV2026R0AccountMappingField?

    /// The tunable settings that control how the shuttle job runs.
    public let settings: ShuttleJobUpdateRequestV2026R0SettingsField?

    /// Initializer for a ShuttleJobUpdateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - name: The human-readable name of the shuttle job.
    ///   - comment: An optional free-form comment describing the shuttle job.
    ///   - tags: A list of free-form tags associated with the shuttle job.
    ///   - accountMapping: The account mapping configuration that controls how source identities
    ///     and permissions are translated into Box.
    ///   - settings: The tunable settings that control how the shuttle job runs.
    public init(name: String? = nil, comment: TriStateField<String> = nil, tags: [String]? = nil, accountMapping: ShuttleJobUpdateRequestV2026R0AccountMappingField? = nil, settings: ShuttleJobUpdateRequestV2026R0SettingsField? = nil) {
        self.name = name
        self._comment = CodableTriState(state: comment)
        self.tags = tags
        self.accountMapping = accountMapping
        self.settings = settings
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        accountMapping = try container.decodeIfPresent(ShuttleJobUpdateRequestV2026R0AccountMappingField.self, forKey: .accountMapping)
        settings = try container.decodeIfPresent(ShuttleJobUpdateRequestV2026R0SettingsField.self, forKey: .settings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(field: _comment.state, forKey: .comment)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(accountMapping, forKey: .accountMapping)
        try container.encodeIfPresent(settings, forKey: .settings)
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
