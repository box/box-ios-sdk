import Foundation

public class RemoveSharedLinkFromWebLinkRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case sharedLink = "shared_link"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// By setting this value to `null`, the shared link
    /// is removed from the web link.
    @CodableTriState public private(set) var sharedLink: RemoveSharedLinkFromWebLinkRequestBodySharedLinkField?

    /// Initializer for a RemoveSharedLinkFromWebLinkRequestBody.
    ///
    /// - Parameters:
    ///   - sharedLink: By setting this value to `null`, the shared link
    ///     is removed from the web link.
    public init(sharedLink: TriStateField<RemoveSharedLinkFromWebLinkRequestBodySharedLinkField> = nil) {
        self._sharedLink = CodableTriState(state: sharedLink)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sharedLink = try container.decodeIfPresent(RemoveSharedLinkFromWebLinkRequestBodySharedLinkField.self, forKey: .sharedLink)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _sharedLink.state, forKey: .sharedLink)
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
