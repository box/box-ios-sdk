import Foundation

public class GetSharedLinkForFolderQueryParams {
    /// Explicitly request the `shared_link` fields
    /// to be returned for this item.
    public let fields: String

    /// Initializer for a GetSharedLinkForFolderQueryParams.
    ///
    /// - Parameters:
    ///   - fields: Explicitly request the `shared_link` fields
    ///     to be returned for this item.
    public init(fields: String) {
        self.fields = fields
    }

}
