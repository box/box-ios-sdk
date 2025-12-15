import Foundation

/// Levels in the metadata taxonomy represent hierarchical 
/// categories within the taxonomy structure.
public class MetadataTaxonomyLevels: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case entries
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// An array of all taxonomy levels.
    public let entries: [MetadataTaxonomyLevel]?

    /// Initializer for a MetadataTaxonomyLevels.
    ///
    /// - Parameters:
    ///   - entries: An array of all taxonomy levels.
    public init(entries: [MetadataTaxonomyLevel]? = nil) {
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decodeIfPresent([MetadataTaxonomyLevel].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(entries, forKey: .entries)
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
