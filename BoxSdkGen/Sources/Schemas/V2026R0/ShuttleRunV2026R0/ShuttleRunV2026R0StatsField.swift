import Foundation

public class ShuttleRunV2026R0StatsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case bytesSent = "bytes_sent"
        case filesSent = "files_sent"
        case foldersCreated = "folders_created"
        case isEstimated = "is_estimated"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Bytes transferred during the run.
    public let bytesSent: Int64?

    /// Files transferred during the run.
    public let filesSent: Int64?

    /// Folders created on the destination during the run.
    public let foldersCreated: Int64?

    /// Whether these figures are estimates rather than final counts.
    public let isEstimated: Bool?

    /// Initializer for a ShuttleRunV2026R0StatsField.
    ///
    /// - Parameters:
    ///   - bytesSent: Bytes transferred during the run.
    ///   - filesSent: Files transferred during the run.
    ///   - foldersCreated: Folders created on the destination during the run.
    ///   - isEstimated: Whether these figures are estimates rather than final counts.
    public init(bytesSent: Int64? = nil, filesSent: Int64? = nil, foldersCreated: Int64? = nil, isEstimated: Bool? = nil) {
        self.bytesSent = bytesSent
        self.filesSent = filesSent
        self.foldersCreated = foldersCreated
        self.isEstimated = isEstimated
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bytesSent = try container.decodeIfPresent(Int64.self, forKey: .bytesSent)
        filesSent = try container.decodeIfPresent(Int64.self, forKey: .filesSent)
        foldersCreated = try container.decodeIfPresent(Int64.self, forKey: .foldersCreated)
        isEstimated = try container.decodeIfPresent(Bool.self, forKey: .isEstimated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bytesSent, forKey: .bytesSent)
        try container.encodeIfPresent(filesSent, forKey: .filesSent)
        try container.encodeIfPresent(foldersCreated, forKey: .foldersCreated)
        try container.encodeIfPresent(isEstimated, forKey: .isEstimated)
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
