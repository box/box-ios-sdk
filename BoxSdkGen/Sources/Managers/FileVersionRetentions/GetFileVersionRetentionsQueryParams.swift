import Foundation

public class GetFileVersionRetentionsQueryParams {
    /// Filters results by files with this ID.
    public let fileId: String?

    /// Filters results by file versions with this ID.
    public let fileVersionId: String?

    /// Filters results by the retention policy with this ID.
    public let policyId: String?

    /// Filters results by the retention policy with this disposition
    /// action.
    public let dispositionAction: GetFileVersionRetentionsQueryParamsDispositionActionField?

    /// Filters results by files that will have their disposition
    /// come into effect before this date.
    public let dispositionBefore: String?

    /// Filters results by files that will have their disposition
    /// come into effect after this date.
    public let dispositionAfter: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// Initializer for a GetFileVersionRetentionsQueryParams.
    ///
    /// - Parameters:
    ///   - fileId: Filters results by files with this ID.
    ///   - fileVersionId: Filters results by file versions with this ID.
    ///   - policyId: Filters results by the retention policy with this ID.
    ///   - dispositionAction: Filters results by the retention policy with this disposition
    ///     action.
    ///   - dispositionBefore: Filters results by files that will have their disposition
    ///     come into effect before this date.
    ///   - dispositionAfter: Filters results by files that will have their disposition
    ///     come into effect after this date.
    ///   - limit: The maximum number of items to return per page.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    public init(fileId: String? = nil, fileVersionId: String? = nil, policyId: String? = nil, dispositionAction: GetFileVersionRetentionsQueryParamsDispositionActionField? = nil, dispositionBefore: String? = nil, dispositionAfter: String? = nil, limit: Int64? = nil, marker: String? = nil) {
        self.fileId = fileId
        self.fileVersionId = fileVersionId
        self.policyId = policyId
        self.dispositionAction = dispositionAction
        self.dispositionBefore = dispositionBefore
        self.dispositionAfter = dispositionAfter
        self.limit = limit
        self.marker = marker
    }

}
