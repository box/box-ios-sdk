import Foundation

/// The mapping scope of a path entry that lives under a shared container
/// such as a site, team drive, bucket, or file share. `type` is the
/// discriminator. Copy `space` onto a shared-space path mapping location
/// when creating a mapping from this row.
public class ShuttlePathEntrySharedSpaceScopeV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case space
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The value will always be `shared_space`.
    public let type: ShuttlePathEntrySharedSpaceScopeV2026R0TypeField

    /// The display name of the shared container this entry belongs to.
    /// `null` when the system has a single implicit container. Maps to
    /// `space` on a shared-space path mapping location.
    @CodableTriState public private(set) var space: String?

    /// Initializer for a ShuttlePathEntrySharedSpaceScopeV2026R0.
    ///
    /// - Parameters:
    ///   - type: The value will always be `shared_space`.
    ///   - space: The display name of the shared container this entry belongs to.
    ///     `null` when the system has a single implicit container. Maps to
    ///     `space` on a shared-space path mapping location.
    public init(type: ShuttlePathEntrySharedSpaceScopeV2026R0TypeField = ShuttlePathEntrySharedSpaceScopeV2026R0TypeField.sharedSpace, space: TriStateField<String> = nil) {
        self.type = type
        self._space = CodableTriState(state: space)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ShuttlePathEntrySharedSpaceScopeV2026R0TypeField.self, forKey: .type)
        space = try container.decodeIfPresent(String.self, forKey: .space)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(field: _space.state, forKey: .space)
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
