import Foundation

/// A reference to a newly created Document Split job. Returned when a Document
/// Split job is accepted for asynchronous processing. Clients can poll the
/// full job representation using this ID.
public class DocumentSplitCreateResponseV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier of the created Document Split job.
    public let id: String

    /// The value will always be `document_split`.
    public let type: DocumentSplitCreateResponseV2026R0TypeField

    /// Initializer for a DocumentSplitCreateResponseV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the created Document Split job.
    ///   - type: The value will always be `document_split`.
    public init(id: String, type: DocumentSplitCreateResponseV2026R0TypeField = DocumentSplitCreateResponseV2026R0TypeField.documentSplit) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(DocumentSplitCreateResponseV2026R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
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
