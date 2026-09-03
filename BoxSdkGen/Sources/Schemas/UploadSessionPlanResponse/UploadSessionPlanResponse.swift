import Foundation

/// Response from planning an upload session.
/// Contains information about which parts already
/// exist (hits) and which need to be uploaded (misses).
public class UploadSessionPlanResponse: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case uploadSessionId = "upload_session_id"
        case hits
        case misses
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for this upload session.
    public let uploadSessionId: String

    /// Parts that already exist on the server and
    /// do not need to be uploaded again.
    public let hits: [UploadPartPlanHit]

    /// Parts that do not exist on the server and
    /// need to be uploaded.
    public let misses: [UploadPartPlan]

    /// Initializer for a UploadSessionPlanResponse.
    ///
    /// - Parameters:
    ///   - uploadSessionId: The unique identifier for this upload session.
    ///   - hits: Parts that already exist on the server and
    ///     do not need to be uploaded again.
    ///   - misses: Parts that do not exist on the server and
    ///     need to be uploaded.
    public init(uploadSessionId: String, hits: [UploadPartPlanHit], misses: [UploadPartPlan]) {
        self.uploadSessionId = uploadSessionId
        self.hits = hits
        self.misses = misses
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uploadSessionId = try container.decode(String.self, forKey: .uploadSessionId)
        hits = try container.decode([UploadPartPlanHit].self, forKey: .hits)
        misses = try container.decode([UploadPartPlan].self, forKey: .misses)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uploadSessionId, forKey: .uploadSessionId)
        try container.encode(hits, forKey: .hits)
        try container.encode(misses, forKey: .misses)
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
