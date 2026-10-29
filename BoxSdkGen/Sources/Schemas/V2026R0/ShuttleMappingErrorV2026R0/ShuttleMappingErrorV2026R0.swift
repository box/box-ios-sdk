import Foundation

/// A problem encountered while preparing path, subject, or permission
/// mappings for a shuttle job.
public class ShuttleMappingErrorV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case jobId = "job_id"
        case revision
        case category
        case path
        case messages
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the mapping error.
    public let id: String

    /// The unique identifier of the shuttle job this error belongs to.
    public let jobId: String

    /// The mapping revision this error belongs to.
    public let revision: Int

    /// The category of mapping work that produced the error. This is an open
    /// string whose set of values can grow.
    public let category: String

    /// The path or subject that the mapping error refers to.
    public let path: String

    /// Human-readable messages describing the mapping error.
    public let messages: [String]

    /// The value will always be `shuttle_mapping_error`.
    public let type: ShuttleMappingErrorV2026R0TypeField

    /// Initializer for a ShuttleMappingErrorV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the mapping error.
    ///   - jobId: The unique identifier of the shuttle job this error belongs to.
    ///   - revision: The mapping revision this error belongs to.
    ///   - category: The category of mapping work that produced the error. This is an open
    ///     string whose set of values can grow.
    ///   - path: The path or subject that the mapping error refers to.
    ///   - messages: Human-readable messages describing the mapping error.
    ///   - type: The value will always be `shuttle_mapping_error`.
    public init(id: String, jobId: String, revision: Int, category: String, path: String, messages: [String], type: ShuttleMappingErrorV2026R0TypeField = ShuttleMappingErrorV2026R0TypeField.shuttleMappingError) {
        self.id = id
        self.jobId = jobId
        self.revision = revision
        self.category = category
        self.path = path
        self.messages = messages
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        jobId = try container.decode(String.self, forKey: .jobId)
        revision = try container.decode(Int.self, forKey: .revision)
        category = try container.decode(String.self, forKey: .category)
        path = try container.decode(String.self, forKey: .path)
        messages = try container.decode([String].self, forKey: .messages)
        type = try container.decode(ShuttleMappingErrorV2026R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(revision, forKey: .revision)
        try container.encode(category, forKey: .category)
        try container.encode(path, forKey: .path)
        try container.encode(messages, forKey: .messages)
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
