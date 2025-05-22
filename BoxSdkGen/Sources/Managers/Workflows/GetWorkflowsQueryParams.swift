import Foundation

public class GetWorkflowsQueryParams {
    /// The unique identifier that represent a folder.
    /// 
    /// The ID for any folder can be determined
    /// by visiting this folder in the web application
    /// and copying the ID from the URL. For example,
    /// for the URL `https://*.app.box.com/folder/123`
    /// the `folder_id` is `123`.
    /// 
    /// The root folder of a Box account is
    /// always represented by the ID `0`.
    public let folderId: String

    /// Type of trigger to search for.
    public let triggerType: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// Initializer for a GetWorkflowsQueryParams.
    ///
    /// - Parameters:
    ///   - folderId: The unique identifier that represent a folder.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting this folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folder/123`
    ///     the `folder_id` is `123`.
    ///     
    ///     The root folder of a Box account is
    ///     always represented by the ID `0`.
    ///   - triggerType: Type of trigger to search for.
    ///   - limit: The maximum number of items to return per page.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    public init(folderId: String, triggerType: String? = nil, limit: Int64? = nil, marker: String? = nil) {
        self.folderId = folderId
        self.triggerType = triggerType
        self.limit = limit
        self.marker = marker
    }

}
