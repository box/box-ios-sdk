import Foundation

/// A standard representation of a Document Split job. The job represents a
/// request to split a paginated source document into multiple files based on
/// either a manual set of page ranges, a non-linear page selection, or a
/// smart prompt-driven analysis.
public class DocumentSplitV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case sourceFile = "source_file"
        case status
        case splitInput = "split_input"
        case destinationFolder = "destination_folder"
        case inputSource = "input_source"
        case type
        case output
        case createdAt = "created_at"
        case createdBy = "created_by"
        case enterprise
        case failures
        case externalId = "external_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the Document Split job.
    public let id: String

    public let sourceFile: FileReferenceV2026R0

    /// The current state of the Document Split job.
    public let status: DocumentSplitV2026R0StatusField

    public let splitInput: DocumentSplitCreateRequestTypeV2026R0

    public let destinationFolder: FolderReferenceV2026R0

    /// The system that initiated the request, used for analytics and
    /// traceability.
    public let inputSource: DocumentSplitV2026R0InputSourceField

    /// The value will always be `document_split`.
    public let type: DocumentSplitV2026R0TypeField

    /// The result of the Document Split job. `null` until the job has produced
    /// output.
    public let output: DocumentSplitOutputV2026R0?

    /// When the Document Split job was created.
    public let createdAt: Date?

    public let createdBy: UserMiniV2026R0?

    public let enterprise: EnterpriseReferenceV2026R0?

    /// Errors and warnings that occurred during the document split. `null` when
    /// no failures were recorded.
    public let failures: DocumentSplitFailuresV2026R0?

    /// An optional identifier supplied by the caller when the Document Split
    /// job was created. Returned for correlation only. It is not a Box
    /// resource ID, is not required to be unique, and cannot be used to
    /// look up the job.
    public let externalId: String?

    /// Initializer for a DocumentSplitV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the Document Split job.
    ///   - sourceFile: 
    ///   - status: The current state of the Document Split job.
    ///   - splitInput: 
    ///   - destinationFolder: 
    ///   - inputSource: The system that initiated the request, used for analytics and
    ///     traceability.
    ///   - type: The value will always be `document_split`.
    ///   - output: The result of the Document Split job. `null` until the job has produced
    ///     output.
    ///   - createdAt: When the Document Split job was created.
    ///   - createdBy: 
    ///   - enterprise: 
    ///   - failures: Errors and warnings that occurred during the document split. `null` when
    ///     no failures were recorded.
    ///   - externalId: An optional identifier supplied by the caller when the Document Split
    ///     job was created. Returned for correlation only. It is not a Box
    ///     resource ID, is not required to be unique, and cannot be used to
    ///     look up the job.
    public init(id: String, sourceFile: FileReferenceV2026R0, status: DocumentSplitV2026R0StatusField, splitInput: DocumentSplitCreateRequestTypeV2026R0, destinationFolder: FolderReferenceV2026R0, inputSource: DocumentSplitV2026R0InputSourceField, type: DocumentSplitV2026R0TypeField = DocumentSplitV2026R0TypeField.documentSplit, output: DocumentSplitOutputV2026R0? = nil, createdAt: Date? = nil, createdBy: UserMiniV2026R0? = nil, enterprise: EnterpriseReferenceV2026R0? = nil, failures: DocumentSplitFailuresV2026R0? = nil, externalId: String? = nil) {
        self.id = id
        self.sourceFile = sourceFile
        self.status = status
        self.splitInput = splitInput
        self.destinationFolder = destinationFolder
        self.inputSource = inputSource
        self.type = type
        self.output = output
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.enterprise = enterprise
        self.failures = failures
        self.externalId = externalId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        sourceFile = try container.decode(FileReferenceV2026R0.self, forKey: .sourceFile)
        status = try container.decode(DocumentSplitV2026R0StatusField.self, forKey: .status)
        splitInput = try container.decode(DocumentSplitCreateRequestTypeV2026R0.self, forKey: .splitInput)
        destinationFolder = try container.decode(FolderReferenceV2026R0.self, forKey: .destinationFolder)
        inputSource = try container.decode(DocumentSplitV2026R0InputSourceField.self, forKey: .inputSource)
        type = try container.decode(DocumentSplitV2026R0TypeField.self, forKey: .type)
        output = try container.decodeIfPresent(DocumentSplitOutputV2026R0.self, forKey: .output)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        createdBy = try container.decodeIfPresent(UserMiniV2026R0.self, forKey: .createdBy)
        enterprise = try container.decodeIfPresent(EnterpriseReferenceV2026R0.self, forKey: .enterprise)
        failures = try container.decodeIfPresent(DocumentSplitFailuresV2026R0.self, forKey: .failures)
        externalId = try container.decodeIfPresent(String.self, forKey: .externalId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(sourceFile, forKey: .sourceFile)
        try container.encode(status, forKey: .status)
        try container.encode(splitInput, forKey: .splitInput)
        try container.encode(destinationFolder, forKey: .destinationFolder)
        try container.encode(inputSource, forKey: .inputSource)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(output, forKey: .output)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(enterprise, forKey: .enterprise)
        try container.encodeIfPresent(failures, forKey: .failures)
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
