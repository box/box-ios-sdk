import Foundation

public class ZipDownloadNameConflictsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case originalName = "original_name"
        case downloadName = "download_name"
    }

    /// The identifier of the item
    public let id: String?

    /// The type of this item
    public let type: ZipDownloadNameConflictsTypeField?

    /// The original name of this item
    public let originalName: String?

    /// The new name of this item as it will appear in the
    /// downloaded `zip` archive.
    public let downloadName: String?

    /// Initializer for a ZipDownloadNameConflictsField.
    ///
    /// - Parameters:
    ///   - id: The identifier of the item
    ///   - type: The type of this item
    ///   - originalName: The original name of this item
    ///   - downloadName: The new name of this item as it will appear in the
    ///     downloaded `zip` archive.
    public init(id: String? = nil, type: ZipDownloadNameConflictsTypeField? = nil, originalName: String? = nil, downloadName: String? = nil) {
        self.id = id
        self.type = type
        self.originalName = originalName
        self.downloadName = downloadName
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(ZipDownloadNameConflictsTypeField.self, forKey: .type)
        originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        downloadName = try container.decodeIfPresent(String.self, forKey: .downloadName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(originalName, forKey: .originalName)
        try container.encodeIfPresent(downloadName, forKey: .downloadName)
    }

}
