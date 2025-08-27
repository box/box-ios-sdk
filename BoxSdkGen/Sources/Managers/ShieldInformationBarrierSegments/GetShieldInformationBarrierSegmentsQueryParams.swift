import Foundation

public class GetShieldInformationBarrierSegmentsQueryParams {
    /// The ID of the shield information barrier.
    public let shieldInformationBarrierId: String

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetShieldInformationBarrierSegmentsQueryParams.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierId: The ID of the shield information barrier.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(shieldInformationBarrierId: String, marker: String? = nil, limit: Int64? = nil) {
        self.shieldInformationBarrierId = shieldInformationBarrierId
        self.marker = marker
        self.limit = limit
    }

}
