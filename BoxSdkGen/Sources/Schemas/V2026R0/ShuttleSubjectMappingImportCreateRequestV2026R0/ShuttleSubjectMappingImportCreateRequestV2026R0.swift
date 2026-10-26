import Foundation

/// The request body used to import a shuttle job's subject mappings from a
/// spreadsheet already stored in Box.
public class ShuttleSubjectMappingImportCreateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
        case fileId = "file_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier of the shuttle job whose subject mappings are
    /// replaced.
    public let jobId: String

    /// The unique identifier of the Box file holding the mapping workbook. The
    /// file is read as the calling user, so it must live somewhere that user can
    /// download from.
    public let fileId: String

    /// Initializer for a ShuttleSubjectMappingImportCreateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - jobId: The unique identifier of the shuttle job whose subject mappings are
    ///     replaced.
    ///   - fileId: The unique identifier of the Box file holding the mapping workbook. The
    ///     file is read as the calling user, so it must live somewhere that user can
    ///     download from.
    public init(jobId: String, fileId: String) {
        self.jobId = jobId
        self.fileId = fileId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jobId = try container.decode(String.self, forKey: .jobId)
        fileId = try container.decode(String.self, forKey: .fileId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(fileId, forKey: .fileId)
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
