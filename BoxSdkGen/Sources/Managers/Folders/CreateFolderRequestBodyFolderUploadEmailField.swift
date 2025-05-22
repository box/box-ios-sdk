import Foundation

public class CreateFolderRequestBodyFolderUploadEmailField: Codable {
    private enum CodingKeys: String, CodingKey {
        case access
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
    public let access: CreateFolderRequestBodyFolderUploadEmailAccessField?

    /// Initializer for a CreateFolderRequestBodyFolderUploadEmailField.
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
    public init(access: CreateFolderRequestBodyFolderUploadEmailAccessField? = nil) {
        self.access = access
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        access = try container.decodeIfPresent(CreateFolderRequestBodyFolderUploadEmailAccessField.self, forKey: .access)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(access, forKey: .access)
    }

}
