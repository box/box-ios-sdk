import Foundation

public class AddShareLinkToFolderQueryParams {
    /// Explicitly request the `shared_link` fields
    /// to be returned for this item.
    public let fields: String

    /// Initializer for a AddShareLinkToFolderQueryParams.
    ///
    /// - Parameters:
    ///   - fields: Explicitly request the `shared_link` fields
    ///     to be returned for this item.
    public init(fields: String) {
        self.fields = fields
    }

}
