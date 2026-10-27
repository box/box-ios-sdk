import Foundation

/// A report generated asynchronously for a shuttle job run. Keep polling
/// while `status` is `pending` or `processing`. Stop when `status` is
/// `complete`, `failed`, `canceled`, or `unknown`. The generated Box file
/// or folder is `null` until generation finishes.
public class ShuttleReportV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case runId = "run_id"
        case status
        case format
        case type
        case sections
        case usersScope = "users_scope"
        case output
        case createdAt = "created_at"
        case completedAt = "completed_at"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the shuttle report.
    public let id: String

    /// The unique identifier of the shuttle run this report was generated
    /// for.
    public let runId: String

    /// The generation status of the report. This is an open string whose set
    /// of values is expected to grow; the currently documented values include
    /// `pending`, `processing`, `complete`, `failed`, `canceled`, and
    /// `unknown`. Keep polling `pending` and `processing`. Stop on
    /// `complete`, `failed`, `canceled`, and `unknown`. Treat any value that
    /// is not recognized the same as `unknown`: do not fail parsing, and do
    /// not keep polling.
    public let status: String

    /// The output file format of the report.
    public let format: ShuttleReportV2026R0FormatField

    /// The value will always be `shuttle_report`.
    public let type: ShuttleReportV2026R0TypeField

    /// The sections included in the report. Echoes the sections requested on
    /// create. This is an open list whose set of values is expected to grow;
    /// the currently documented values include `files_and_folders`,
    /// `event_log`, `transfer_overview`, `source_users`, `target_users`,
    /// `source_collaborators`, `target_collaborators`,
    /// `source_collaborations`, and `target_collaborations`. Omitted on
    /// older reports that have no stored section list. New reports always
    /// include this field.
    public let sections: [String]?

    /// Which users are included in user-related report sections.
    public let usersScope: ShuttleReportV2026R0UsersScopeField?

    /// The generated Box file or folder. Always present; `null` until
    /// `status` is `complete`.
    public let output: ShuttleReportOutputV2026R0?

    /// When report generation was requested.
    public let createdAt: Date?

    /// When report generation finished. Always present; `null` while
    /// generation is still in progress.
    @CodableTriState public private(set) var completedAt: Date?

    /// Initializer for a ShuttleReportV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shuttle report.
    ///   - runId: The unique identifier of the shuttle run this report was generated
    ///     for.
    ///   - status: The generation status of the report. This is an open string whose set
    ///     of values is expected to grow; the currently documented values include
    ///     `pending`, `processing`, `complete`, `failed`, `canceled`, and
    ///     `unknown`. Keep polling `pending` and `processing`. Stop on
    ///     `complete`, `failed`, `canceled`, and `unknown`. Treat any value that
    ///     is not recognized the same as `unknown`: do not fail parsing, and do
    ///     not keep polling.
    ///   - format: The output file format of the report.
    ///   - type: The value will always be `shuttle_report`.
    ///   - sections: The sections included in the report. Echoes the sections requested on
    ///     create. This is an open list whose set of values is expected to grow;
    ///     the currently documented values include `files_and_folders`,
    ///     `event_log`, `transfer_overview`, `source_users`, `target_users`,
    ///     `source_collaborators`, `target_collaborators`,
    ///     `source_collaborations`, and `target_collaborations`. Omitted on
    ///     older reports that have no stored section list. New reports always
    ///     include this field.
    ///   - usersScope: Which users are included in user-related report sections.
    ///   - output: The generated Box file or folder. Always present; `null` until
    ///     `status` is `complete`.
    ///   - createdAt: When report generation was requested.
    ///   - completedAt: When report generation finished. Always present; `null` while
    ///     generation is still in progress.
    public init(id: String, runId: String, status: String, format: ShuttleReportV2026R0FormatField, type: ShuttleReportV2026R0TypeField = ShuttleReportV2026R0TypeField.shuttleReport, sections: [String]? = nil, usersScope: ShuttleReportV2026R0UsersScopeField? = nil, output: ShuttleReportOutputV2026R0? = nil, createdAt: Date? = nil, completedAt: TriStateField<Date> = nil) {
        self.id = id
        self.runId = runId
        self.status = status
        self.format = format
        self.type = type
        self.sections = sections
        self.usersScope = usersScope
        self.output = output
        self.createdAt = createdAt
        self._completedAt = CodableTriState(state: completedAt)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        runId = try container.decode(String.self, forKey: .runId)
        status = try container.decode(String.self, forKey: .status)
        format = try container.decode(ShuttleReportV2026R0FormatField.self, forKey: .format)
        type = try container.decode(ShuttleReportV2026R0TypeField.self, forKey: .type)
        sections = try container.decodeIfPresent([String].self, forKey: .sections)
        usersScope = try container.decodeIfPresent(ShuttleReportV2026R0UsersScopeField.self, forKey: .usersScope)
        output = try container.decodeIfPresent(ShuttleReportOutputV2026R0.self, forKey: .output)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        completedAt = try container.decodeDateTimeIfPresent(forKey: .completedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(runId, forKey: .runId)
        try container.encode(status, forKey: .status)
        try container.encode(format, forKey: .format)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(sections, forKey: .sections)
        try container.encodeIfPresent(usersScope, forKey: .usersScope)
        try container.encodeIfPresent(output, forKey: .output)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTime(field: _completedAt.state, forKey: .completedAt)
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
