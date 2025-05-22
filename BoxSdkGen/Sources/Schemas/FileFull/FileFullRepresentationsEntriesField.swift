import Foundation

public class FileFullRepresentationsEntriesField: Codable {
    private enum CodingKeys: String, CodingKey {
        case content
        case info
        case properties
        case representation
        case status
    }

    /// An object containing the URL that can be used to actually fetch
    /// the representation.
    public let content: FileFullRepresentationsEntriesContentField?

    /// An object containing the URL that can be used to fetch more info
    /// on this representation.
    public let info: FileFullRepresentationsEntriesInfoField?

    /// An object containing the size and type of this presentation.
    public let properties: FileFullRepresentationsEntriesPropertiesField?

    /// Indicates the file type of the returned representation.
    public let representation: String?

    /// An object containing the status of this representation.
    public let status: FileFullRepresentationsEntriesStatusField?

    /// Initializer for a FileFullRepresentationsEntriesField.
    ///
    /// - Parameters:
    ///   - content: An object containing the URL that can be used to actually fetch
    ///     the representation.
    ///   - info: An object containing the URL that can be used to fetch more info
    ///     on this representation.
    ///   - properties: An object containing the size and type of this presentation.
    ///   - representation: Indicates the file type of the returned representation.
    ///   - status: An object containing the status of this representation.
    public init(content: FileFullRepresentationsEntriesContentField? = nil, info: FileFullRepresentationsEntriesInfoField? = nil, properties: FileFullRepresentationsEntriesPropertiesField? = nil, representation: String? = nil, status: FileFullRepresentationsEntriesStatusField? = nil) {
        self.content = content
        self.info = info
        self.properties = properties
        self.representation = representation
        self.status = status
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decodeIfPresent(FileFullRepresentationsEntriesContentField.self, forKey: .content)
        info = try container.decodeIfPresent(FileFullRepresentationsEntriesInfoField.self, forKey: .info)
        properties = try container.decodeIfPresent(FileFullRepresentationsEntriesPropertiesField.self, forKey: .properties)
        representation = try container.decodeIfPresent(String.self, forKey: .representation)
        status = try container.decodeIfPresent(FileFullRepresentationsEntriesStatusField.self, forKey: .status)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(info, forKey: .info)
        try container.encodeIfPresent(properties, forKey: .properties)
        try container.encodeIfPresent(representation, forKey: .representation)
        try container.encodeIfPresent(status, forKey: .status)
    }

}
