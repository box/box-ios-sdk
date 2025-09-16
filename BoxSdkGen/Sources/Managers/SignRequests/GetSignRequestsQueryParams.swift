import Foundation

public class GetSignRequestsQueryParams {
    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// A list of sender emails to filter the signature requests by sender.
    /// If provided, `shared_requests` must be set to `true`.
    public let senders: [String]?

    /// If set to `true`, only includes requests that user is not an owner,
    /// but user is a collaborator. Collaborator access is determined by the
    /// user access level of the sign files of the request.
    /// Default is `false`. Must be set to `true` if `senders` are provided.
    public let sharedRequests: Bool?

    /// Initializer for a GetSignRequestsQueryParams.
    ///
    /// - Parameters:
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    ///   - senders: A list of sender emails to filter the signature requests by sender.
    ///     If provided, `shared_requests` must be set to `true`.
    ///   - sharedRequests: If set to `true`, only includes requests that user is not an owner,
    ///     but user is a collaborator. Collaborator access is determined by the
    ///     user access level of the sign files of the request.
    ///     Default is `false`. Must be set to `true` if `senders` are provided.
    public init(marker: String? = nil, limit: Int64? = nil, senders: [String]? = nil, sharedRequests: Bool? = nil) {
        self.marker = marker
        self.limit = limit
        self.senders = senders
        self.sharedRequests = sharedRequests
    }

}
