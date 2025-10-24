import Foundation

/// The shared link permissions for the enterprise.
public class SharedLinkPermissionsV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case sharedLinksOption = "shared_links_option"
        case defaultSharedLinkType = "default_shared_link_type"
        case notesSharedLinkOption = "notes_shared_link_option"
        case defaultNotesSharedLinkType = "default_notes_shared_link_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The selected option for shared links permissions.
    @CodableTriState public private(set) var sharedLinksOption: String?

    /// The default shared link type.
    @CodableTriState public private(set) var defaultSharedLinkType: String?

    /// The selected option for notes shared links permissions.
    @CodableTriState public private(set) var notesSharedLinkOption: String?

    /// The default notes shared link type.
    @CodableTriState public private(set) var defaultNotesSharedLinkType: String?

    /// Initializer for a SharedLinkPermissionsV2025R0.
    ///
    /// - Parameters:
    ///   - sharedLinksOption: The selected option for shared links permissions.
    ///   - defaultSharedLinkType: The default shared link type.
    ///   - notesSharedLinkOption: The selected option for notes shared links permissions.
    ///   - defaultNotesSharedLinkType: The default notes shared link type.
    public init(sharedLinksOption: TriStateField<String> = nil, defaultSharedLinkType: TriStateField<String> = nil, notesSharedLinkOption: TriStateField<String> = nil, defaultNotesSharedLinkType: TriStateField<String> = nil) {
        self._sharedLinksOption = CodableTriState(state: sharedLinksOption)
        self._defaultSharedLinkType = CodableTriState(state: defaultSharedLinkType)
        self._notesSharedLinkOption = CodableTriState(state: notesSharedLinkOption)
        self._defaultNotesSharedLinkType = CodableTriState(state: defaultNotesSharedLinkType)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sharedLinksOption = try container.decodeIfPresent(String.self, forKey: .sharedLinksOption)
        defaultSharedLinkType = try container.decodeIfPresent(String.self, forKey: .defaultSharedLinkType)
        notesSharedLinkOption = try container.decodeIfPresent(String.self, forKey: .notesSharedLinkOption)
        defaultNotesSharedLinkType = try container.decodeIfPresent(String.self, forKey: .defaultNotesSharedLinkType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _sharedLinksOption.state, forKey: .sharedLinksOption)
        try container.encode(field: _defaultSharedLinkType.state, forKey: .defaultSharedLinkType)
        try container.encode(field: _notesSharedLinkOption.state, forKey: .notesSharedLinkOption)
        try container.encode(field: _defaultNotesSharedLinkType.state, forKey: .defaultNotesSharedLinkType)
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
