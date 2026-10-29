import Foundation

/// The request body used to update an existing shuttle subject mapping. Only
/// the fields supplied in the request body are changed. `job_id`, `id`,
/// `type`, `source`, `discovered_subject_id`, and `revision` are immutable.
public class ShuttleSubjectMappingUpdateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case isSubjectSkipped = "is_subject_skipped"
        case target
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether this subject should be skipped during the migration.
    public let isSubjectSkipped: Bool?

    /// The Box target to map to. Set to `null` only for a skipped subject.
    /// Setting it to `null` while the mapping is active fails validation.
    /// Updating `is_subject_skipped` alone preserves the existing target.
    public let target: ShuttleTargetSubjectInputV2026R0?

    /// Initializer for a ShuttleSubjectMappingUpdateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - isSubjectSkipped: Whether this subject should be skipped during the migration.
    ///   - target: The Box target to map to. Set to `null` only for a skipped subject.
    ///     Setting it to `null` while the mapping is active fails validation.
    ///     Updating `is_subject_skipped` alone preserves the existing target.
    public init(isSubjectSkipped: Bool? = nil, target: ShuttleTargetSubjectInputV2026R0? = nil) {
        self.isSubjectSkipped = isSubjectSkipped
        self.target = target
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSubjectSkipped = try container.decodeIfPresent(Bool.self, forKey: .isSubjectSkipped)
        target = try container.decodeIfPresent(ShuttleTargetSubjectInputV2026R0.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isSubjectSkipped, forKey: .isSubjectSkipped)
        try container.encodeIfPresent(target, forKey: .target)
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
