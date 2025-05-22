import Foundation

public class FileFullRepresentationsEntriesPropertiesField: Codable {
    private enum CodingKeys: String, CodingKey {
        case dimensions
        case paged
        case thumb
    }

    /// The width by height size of this representation in pixels.
    public let dimensions: String?

    /// Indicates if the representation is build up out of multiple
    /// pages.
    public let paged: String?

    /// Indicates if the representation can be used as a thumbnail of
    /// the file.
    public let thumb: String?

    /// Initializer for a FileFullRepresentationsEntriesPropertiesField.
    ///
    /// - Parameters:
    ///   - dimensions: The width by height size of this representation in pixels.
    ///   - paged: Indicates if the representation is build up out of multiple
    ///     pages.
    ///   - thumb: Indicates if the representation can be used as a thumbnail of
    ///     the file.
    public init(dimensions: String? = nil, paged: String? = nil, thumb: String? = nil) {
        self.dimensions = dimensions
        self.paged = paged
        self.thumb = thumb
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dimensions = try container.decodeIfPresent(String.self, forKey: .dimensions)
        paged = try container.decodeIfPresent(String.self, forKey: .paged)
        thumb = try container.decodeIfPresent(String.self, forKey: .thumb)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(dimensions, forKey: .dimensions)
        try container.encodeIfPresent(paged, forKey: .paged)
        try container.encodeIfPresent(thumb, forKey: .thumb)
    }

}
