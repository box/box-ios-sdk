import Foundation

public class GetFolderAppItemAssociationsQueryParams {
    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// If given, returns only app items for this application type
    public let applicationType: String?

    /// Initializer for a GetFolderAppItemAssociationsQueryParams.
    ///
    /// - Parameters:
    ///   - limit: The maximum number of items to return per page.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - applicationType: If given, returns only app items for this application type
    public init(limit: Int64? = nil, marker: String? = nil, applicationType: String? = nil) {
        self.limit = limit
        self.marker = marker
        self.applicationType = applicationType
    }

}
