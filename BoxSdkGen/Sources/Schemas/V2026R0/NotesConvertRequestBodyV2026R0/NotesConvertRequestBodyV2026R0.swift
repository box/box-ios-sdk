import Foundation

/// Request body for converting source content into a Box Note file.
public class NotesConvertRequestBodyV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case content
        case parent
        case name
        case contentFormat = "content_format"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The content to convert to a note. See the `content_format` field for supported formats.
    public let content: String

    public let parent: FolderReferenceV2026R0

    /// The name for the created note. The `.boxnote` extension is appended automatically.
    public let name: String

    /// Format of the content to convert.
    public let contentFormat: NotesConvertRequestBodyV2026R0ContentFormatField

    /// Initializer for a NotesConvertRequestBodyV2026R0.
    ///
    /// - Parameters:
    ///   - content: The content to convert to a note. See the `content_format` field for supported formats.
    ///   - parent: 
    ///   - name: The name for the created note. The `.boxnote` extension is appended automatically.
    ///   - contentFormat: Format of the content to convert.
    public init(content: String, parent: FolderReferenceV2026R0, name: String, contentFormat: NotesConvertRequestBodyV2026R0ContentFormatField = NotesConvertRequestBodyV2026R0ContentFormatField.markdown) {
        self.content = content
        self.parent = parent
        self.name = name
        self.contentFormat = contentFormat
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(String.self, forKey: .content)
        parent = try container.decode(FolderReferenceV2026R0.self, forKey: .parent)
        name = try container.decode(String.self, forKey: .name)
        contentFormat = try container.decode(NotesConvertRequestBodyV2026R0ContentFormatField.self, forKey: .contentFormat)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(parent, forKey: .parent)
        try container.encode(name, forKey: .name)
        try container.encode(contentFormat, forKey: .contentFormat)
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
