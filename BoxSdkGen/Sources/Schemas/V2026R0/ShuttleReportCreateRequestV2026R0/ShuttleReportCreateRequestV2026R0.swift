import Foundation

/// The request body used to generate a report for a shuttle run. Generation
/// is asynchronous: the created report is returned immediately in `pending`
/// or `processing` status. Poll `GET /shuttle_reports/{shuttle_report_id}`
/// while `status` is `pending` or `processing`. Stop when `status` is
/// `complete`, `failed`, `canceled`, or `unknown`. Repeating this request
/// with the same parameters reuses the existing report instead of creating
/// a duplicate.
public class ShuttleReportCreateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case runId = "run_id"
        case format
        case sections
        case usersScope = "users_scope"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier of the shuttle run to generate a report for.
    public let runId: String

    /// The output file format of the report.
    public let format: ShuttleReportCreateRequestV2026R0FormatField

    /// The sections to include in the report. Must be a non-empty subset of
    /// the run's `available_report_sections`. This is an open list whose set
    /// of values is expected to grow; the currently documented values include
    /// `files_and_folders`, `event_log`, `transfer_overview`, `source_users`,
    /// `target_users`, `source_collaborators`, `target_collaborators`,
    /// `source_collaborations`, and `target_collaborations`.
    public let sections: [String]

    /// Which users to include in user-related report sections. Defaults to
    /// `migrated` when omitted.
    public let usersScope: ShuttleReportCreateRequestV2026R0UsersScopeField?

    /// Initializer for a ShuttleReportCreateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - runId: The unique identifier of the shuttle run to generate a report for.
    ///   - format: The output file format of the report.
    ///   - sections: The sections to include in the report. Must be a non-empty subset of
    ///     the run's `available_report_sections`. This is an open list whose set
    ///     of values is expected to grow; the currently documented values include
    ///     `files_and_folders`, `event_log`, `transfer_overview`, `source_users`,
    ///     `target_users`, `source_collaborators`, `target_collaborators`,
    ///     `source_collaborations`, and `target_collaborations`.
    ///   - usersScope: Which users to include in user-related report sections. Defaults to
    ///     `migrated` when omitted.
    public init(runId: String, format: ShuttleReportCreateRequestV2026R0FormatField, sections: [String], usersScope: ShuttleReportCreateRequestV2026R0UsersScopeField? = nil) {
        self.runId = runId
        self.format = format
        self.sections = sections
        self.usersScope = usersScope
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        runId = try container.decode(String.self, forKey: .runId)
        format = try container.decode(ShuttleReportCreateRequestV2026R0FormatField.self, forKey: .format)
        sections = try container.decode([String].self, forKey: .sections)
        usersScope = try container.decodeIfPresent(ShuttleReportCreateRequestV2026R0UsersScopeField.self, forKey: .usersScope)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(runId, forKey: .runId)
        try container.encode(format, forKey: .format)
        try container.encode(sections, forKey: .sections)
        try container.encodeIfPresent(usersScope, forKey: .usersScope)
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
