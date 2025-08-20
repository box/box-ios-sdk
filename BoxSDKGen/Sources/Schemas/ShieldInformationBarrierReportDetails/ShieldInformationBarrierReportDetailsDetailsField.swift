import Foundation

public class ShieldInformationBarrierReportDetailsDetailsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case folderId = "folder_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Folder ID for locating this report.
    public let folderId: String?

    /// Initializer for a ShieldInformationBarrierReportDetailsDetailsField.
    ///
    /// - Parameters:
    ///   - folderId: Folder ID for locating this report.
    public init(folderId: String? = nil) {
        self.folderId = folderId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        folderId = try container.decodeIfPresent(String.self, forKey: .folderId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(folderId, forKey: .folderId)
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
