import Foundation

/// The path of folders to an item, starting at the root.
public class PathCollection: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Number of entries in a path
    public let totalCount: Int?
    /// Entries (folders) in a path to an item
    public let entries: [Folder]?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        totalCount = try BoxJSONDecoder.optionalDecode(json: json, forKey: "total_count")
        entries = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "entries")
    }
}
