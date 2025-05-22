import Foundation

/// The request body to update a file request.
public class FileRequestUpdateRequest: Codable {
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case status
        case isEmailRequired = "is_email_required"
        case isDescriptionRequired = "is_description_required"
        case expiresAt = "expires_at"
    }

    /// An optional new title for the file request. This can be
    /// used to change the title of the file request.
    /// 
    /// This will default to the value on the existing file request.
    public let title: String?

    /// An optional new description for the file request. This can be
    /// used to change the description of the file request.
    /// 
    /// This will default to the value on the existing file request.
    public let description: String?

    /// An optional new status of the file request.
    /// 
    /// When the status is set to `inactive`, the file request
    /// will no longer accept new submissions, and any visitor
    /// to the file request URL will receive a `HTTP 404` status
    /// code.
    /// 
    /// This will default to the value on the existing file request.
    public let status: FileRequestUpdateRequestStatusField?

    /// Whether a file request submitter is required to provide
    /// their email address.
    /// 
    /// When this setting is set to true, the Box UI will show
    /// an email field on the file request form.
    /// 
    /// This will default to the value on the existing file request.
    public let isEmailRequired: Bool?

    /// Whether a file request submitter is required to provide
    /// a description of the files they are submitting.
    /// 
    /// When this setting is set to true, the Box UI will show
    /// a description field on the file request form.
    /// 
    /// This will default to the value on the existing file request.
    public let isDescriptionRequired: Bool?

    /// The date after which a file request will no longer accept new
    /// submissions.
    /// 
    /// After this date, the `status` will automatically be set to
    /// `inactive`.
    /// 
    /// This will default to the value on the existing file request.
    public let expiresAt: Date?

    /// Initializer for a FileRequestUpdateRequest.
    ///
    /// - Parameters:
    ///   - title: An optional new title for the file request. This can be
    ///     used to change the title of the file request.
    ///     
    ///     This will default to the value on the existing file request.
    ///   - description: An optional new description for the file request. This can be
    ///     used to change the description of the file request.
    ///     
    ///     This will default to the value on the existing file request.
    ///   - status: An optional new status of the file request.
    ///     
    ///     When the status is set to `inactive`, the file request
    ///     will no longer accept new submissions, and any visitor
    ///     to the file request URL will receive a `HTTP 404` status
    ///     code.
    ///     
    ///     This will default to the value on the existing file request.
    ///   - isEmailRequired: Whether a file request submitter is required to provide
    ///     their email address.
    ///     
    ///     When this setting is set to true, the Box UI will show
    ///     an email field on the file request form.
    ///     
    ///     This will default to the value on the existing file request.
    ///   - isDescriptionRequired: Whether a file request submitter is required to provide
    ///     a description of the files they are submitting.
    ///     
    ///     When this setting is set to true, the Box UI will show
    ///     a description field on the file request form.
    ///     
    ///     This will default to the value on the existing file request.
    ///   - expiresAt: The date after which a file request will no longer accept new
    ///     submissions.
    ///     
    ///     After this date, the `status` will automatically be set to
    ///     `inactive`.
    ///     
    ///     This will default to the value on the existing file request.
    public init(title: String? = nil, description: String? = nil, status: FileRequestUpdateRequestStatusField? = nil, isEmailRequired: Bool? = nil, isDescriptionRequired: Bool? = nil, expiresAt: Date? = nil) {
        self.title = title
        self.description = description
        self.status = status
        self.isEmailRequired = isEmailRequired
        self.isDescriptionRequired = isDescriptionRequired
        self.expiresAt = expiresAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        status = try container.decodeIfPresent(FileRequestUpdateRequestStatusField.self, forKey: .status)
        isEmailRequired = try container.decodeIfPresent(Bool.self, forKey: .isEmailRequired)
        isDescriptionRequired = try container.decodeIfPresent(Bool.self, forKey: .isDescriptionRequired)
        expiresAt = try container.decodeDateTimeIfPresent(forKey: .expiresAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(isEmailRequired, forKey: .isEmailRequired)
        try container.encodeIfPresent(isDescriptionRequired, forKey: .isDescriptionRequired)
        try container.encodeDateTimeIfPresent(field: expiresAt, forKey: .expiresAt)
    }

}
