import Foundation

public class GetShieldInformationBarrierSegmentMembersQueryParams {
    /// The ID of the shield information barrier segment.
    public let shieldInformationBarrierSegmentId: String

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetShieldInformationBarrierSegmentMembersQueryParams.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegmentId: The ID of the shield information barrier segment.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(shieldInformationBarrierSegmentId: String, marker: String? = nil, limit: Int64? = nil) {
        self.shieldInformationBarrierSegmentId = shieldInformationBarrierSegmentId
        self.marker = marker
        self.limit = limit
    }

}
