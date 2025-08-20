import Foundation

public class FolderFolderUploadEmailField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case access
        case email
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// When this parameter has been set, users can email files
    /// to the email address that has been automatically
    /// created for this folder.
    /// 
    /// To create an email address, set this property either when
    /// creating or updating the folder.
    /// 
    /// When set to `collaborators`, only emails from registered email
    /// addresses for collaborators will be accepted. This includes
    /// any email aliases a user might have registered.
    /// 
    /// When set to `open` it will accept emails from any email
    /// address.
    public let access: FolderFolderUploadEmailAccessField?

    /// The optional upload email address for this folder.
    public let email: String?

    /// Initializer for a FolderFolderUploadEmailField.
    ///
    /// - Parameters:
    ///   - access: When this parameter has been set, users can email files
    ///     to the email address that has been automatically
    ///     created for this folder.
    ///     
    ///     To create an email address, set this property either when
    ///     creating or updating the folder.
    ///     
    ///     When set to `collaborators`, only emails from registered email
    ///     addresses for collaborators will be accepted. This includes
    ///     any email aliases a user might have registered.
    ///     
    ///     When set to `open` it will accept emails from any email
    ///     address.
    ///   - email: The optional upload email address for this folder.
    public init(access: FolderFolderUploadEmailAccessField? = nil, email: String? = nil) {
        self.access = access
        self.email = email
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        access = try container.decodeIfPresent(FolderFolderUploadEmailAccessField.self, forKey: .access)
        email = try container.decodeIfPresent(String.self, forKey: .email)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(access, forKey: .access)
        try container.encodeIfPresent(email, forKey: .email)
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
