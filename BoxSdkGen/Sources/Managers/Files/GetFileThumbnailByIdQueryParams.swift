import Foundation

public class GetFileThumbnailByIdQueryParams {
    /// The minimum height of the thumbnail
    public let minHeight: Int64?

    /// The minimum width of the thumbnail
    public let minWidth: Int64?

    /// The maximum height of the thumbnail
    public let maxHeight: Int64?

    /// The maximum width of the thumbnail
    public let maxWidth: Int64?

    /// Initializer for a GetFileThumbnailByIdQueryParams.
    ///
    /// - Parameters:
    ///   - minHeight: The minimum height of the thumbnail
    ///   - minWidth: The minimum width of the thumbnail
    ///   - maxHeight: The maximum height of the thumbnail
    ///   - maxWidth: The maximum width of the thumbnail
    public init(minHeight: Int64? = nil, minWidth: Int64? = nil, maxHeight: Int64? = nil, maxWidth: Int64? = nil) {
        self.minHeight = minHeight
        self.minWidth = minWidth
        self.maxHeight = maxHeight
        self.maxWidth = maxWidth
    }

}
