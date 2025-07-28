import Foundation

/// The request body to copy a file request.
public class FileRequestCopyRequest: FileRequestUpdateRequest {
    private enum CodingKeys: String, CodingKey {
        case folder
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// The folder to associate the new file request to.
    public let folder: FileRequestCopyRequestFolderField

    /// Initializer for a FileRequestCopyRequest.
    ///
    /// - Parameters:
    ///   - folder: The folder to associate the new file request to.
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
    public init(folder: FileRequestCopyRequestFolderField, title: String? = nil, description: String? = nil, status: FileRequestUpdateRequestStatusField? = nil, isEmailRequired: Bool? = nil, isDescriptionRequired: Bool? = nil, expiresAt: Date? = nil) {
        self.folder = folder

        super.init(title: title, description: description, status: status, isEmailRequired: isEmailRequired, isDescriptionRequired: isDescriptionRequired, expiresAt: expiresAt)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        folder = try container.decode(FileRequestCopyRequestFolderField.self, forKey: .folder)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(folder, forKey: .folder)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
