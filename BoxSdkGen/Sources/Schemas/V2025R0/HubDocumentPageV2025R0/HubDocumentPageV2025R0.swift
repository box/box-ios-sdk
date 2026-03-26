import Foundation

/// A Page in the Box Hub Document.
public class HubDocumentPageV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case titleFragment = "title_fragment"
        case parentId = "parent_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for this page.
    public let id: String

    /// The type of this resource. The value is always `page`.
    public let type: String

    /// The title text of the page. Includes rich text formatting.
    public let titleFragment: String

    /// The unique identifier of the parent page. Null for root-level pages.
    @CodableTriState public private(set) var parentId: String?

    /// Initializer for a HubDocumentPageV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this page.
    ///   - type: The type of this resource. The value is always `page`.
    ///   - titleFragment: The title text of the page. Includes rich text formatting.
    ///   - parentId: The unique identifier of the parent page. Null for root-level pages.
    public init(id: String, type: String, titleFragment: String, parentId: TriStateField<String> = nil) {
        self.id = id
        self.type = type
        self.titleFragment = titleFragment
        self._parentId = CodableTriState(state: parentId)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        titleFragment = try container.decode(String.self, forKey: .titleFragment)
        parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(titleFragment, forKey: .titleFragment)
        try container.encode(field: _parentId.state, forKey: .parentId)
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
