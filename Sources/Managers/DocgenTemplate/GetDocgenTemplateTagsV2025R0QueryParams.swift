import Foundation

public class GetDocgenTemplateTagsV2025R0QueryParams {
    /// Id of template version.
    public let templateVersionId: String?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetDocgenTemplateTagsV2025R0QueryParams.
    ///
    /// - Parameters:
    ///   - templateVersionId: Id of template version.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(templateVersionId: String? = nil, marker: String? = nil, limit: Int64? = nil) {
        self.templateVersionId = templateVersionId
        self.marker = marker
        self.limit = limit
    }

}
