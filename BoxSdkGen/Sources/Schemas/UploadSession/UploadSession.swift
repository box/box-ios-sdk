import Foundation

/// An upload session for chunk uploading a file.
public class UploadSession: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case sessionExpiresAt = "session_expires_at"
        case partSize = "part_size"
        case totalParts = "total_parts"
        case numPartsProcessed = "num_parts_processed"
        case sessionEndpoints = "session_endpoints"
    }

    /// The unique identifier for this session
    public let id: String?

    /// `upload_session`
    public let type: UploadSessionTypeField?

    /// The date and time when this session expires.
    public let sessionExpiresAt: Date?

    /// The  size in bytes that must be used for all parts of of the
    /// upload.
    /// 
    /// Only the last part is allowed to be of a smaller size.
    public let partSize: Int64?

    /// The total number of parts expected in this upload session,
    /// as determined by the file size and part size.
    public let totalParts: Int?

    /// The number of parts that have been uploaded and processed
    /// by the server. This starts at `0`.
    /// 
    /// When committing a file files, inspecting this property can
    /// provide insight if all parts have been uploaded correctly.
    public let numPartsProcessed: Int?

    public let sessionEndpoints: UploadSessionSessionEndpointsField?

    /// Initializer for a UploadSession.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this session
    ///   - type: `upload_session`
    ///   - sessionExpiresAt: The date and time when this session expires.
    ///   - partSize: The  size in bytes that must be used for all parts of of the
    ///     upload.
    ///     
    ///     Only the last part is allowed to be of a smaller size.
    ///   - totalParts: The total number of parts expected in this upload session,
    ///     as determined by the file size and part size.
    ///   - numPartsProcessed: The number of parts that have been uploaded and processed
    ///     by the server. This starts at `0`.
    ///     
    ///     When committing a file files, inspecting this property can
    ///     provide insight if all parts have been uploaded correctly.
    ///   - sessionEndpoints: 
    public init(id: String? = nil, type: UploadSessionTypeField? = nil, sessionExpiresAt: Date? = nil, partSize: Int64? = nil, totalParts: Int? = nil, numPartsProcessed: Int? = nil, sessionEndpoints: UploadSessionSessionEndpointsField? = nil) {
        self.id = id
        self.type = type
        self.sessionExpiresAt = sessionExpiresAt
        self.partSize = partSize
        self.totalParts = totalParts
        self.numPartsProcessed = numPartsProcessed
        self.sessionEndpoints = sessionEndpoints
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(UploadSessionTypeField.self, forKey: .type)
        sessionExpiresAt = try container.decodeDateTimeIfPresent(forKey: .sessionExpiresAt)
        partSize = try container.decodeIfPresent(Int64.self, forKey: .partSize)
        totalParts = try container.decodeIfPresent(Int.self, forKey: .totalParts)
        numPartsProcessed = try container.decodeIfPresent(Int.self, forKey: .numPartsProcessed)
        sessionEndpoints = try container.decodeIfPresent(UploadSessionSessionEndpointsField.self, forKey: .sessionEndpoints)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeDateTimeIfPresent(field: sessionExpiresAt, forKey: .sessionExpiresAt)
        try container.encodeIfPresent(partSize, forKey: .partSize)
        try container.encodeIfPresent(totalParts, forKey: .totalParts)
        try container.encodeIfPresent(numPartsProcessed, forKey: .numPartsProcessed)
        try container.encodeIfPresent(sessionEndpoints, forKey: .sessionEndpoints)
    }

}
