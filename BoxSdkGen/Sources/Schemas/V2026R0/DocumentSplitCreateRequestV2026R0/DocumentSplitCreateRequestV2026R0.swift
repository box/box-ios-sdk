import Foundation

/// The request body for creating a Document Split job. The `split_input`
/// property carries the caller-supplied input that determines how the split
/// is performed.
public class DocumentSplitCreateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case sourceFileId = "source_file_id"
        case destinationFolderId = "destination_folder_id"
        case inputSource = "input_source"
        case splitInput = "split_input"
        case externalId = "external_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The ID of the source file to split.
    public let sourceFileId: String

    /// The ID of the folder where the resulting files will be uploaded.
    public let destinationFolderId: String

    /// The system that initiated the request, used for analytics and
    /// traceability.
    public let inputSource: DocumentSplitCreateRequestV2026R0InputSourceField

    public let splitInput: DocumentSplitCreateRequestTypeV2026R0

    /// An optional identifier supplied by the caller for this Document Split job.
    /// The value is returned on job responses for correlation only. It is not
    /// a Box resource ID, is not required to be unique, and cannot be used to
    /// look up the job.
    public let externalId: String?

    /// Initializer for a DocumentSplitCreateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - sourceFileId: The ID of the source file to split.
    ///   - destinationFolderId: The ID of the folder where the resulting files will be uploaded.
    ///   - inputSource: The system that initiated the request, used for analytics and
    ///     traceability.
    ///   - splitInput: 
    ///   - externalId: An optional identifier supplied by the caller for this Document Split job.
    ///     The value is returned on job responses for correlation only. It is not
    ///     a Box resource ID, is not required to be unique, and cannot be used to
    ///     look up the job.
    public init(sourceFileId: String, destinationFolderId: String, inputSource: DocumentSplitCreateRequestV2026R0InputSourceField, splitInput: DocumentSplitCreateRequestTypeV2026R0, externalId: String? = nil) {
        self.sourceFileId = sourceFileId
        self.destinationFolderId = destinationFolderId
        self.inputSource = inputSource
        self.splitInput = splitInput
        self.externalId = externalId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceFileId = try container.decode(String.self, forKey: .sourceFileId)
        destinationFolderId = try container.decode(String.self, forKey: .destinationFolderId)
        inputSource = try container.decode(DocumentSplitCreateRequestV2026R0InputSourceField.self, forKey: .inputSource)
        splitInput = try container.decode(DocumentSplitCreateRequestTypeV2026R0.self, forKey: .splitInput)
        externalId = try container.decodeIfPresent(String.self, forKey: .externalId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sourceFileId, forKey: .sourceFileId)
        try container.encode(destinationFolderId, forKey: .destinationFolderId)
        try container.encode(inputSource, forKey: .inputSource)
        try container.encode(splitInput, forKey: .splitInput)
        try container.encodeIfPresent(externalId, forKey: .externalId)
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
