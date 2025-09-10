import Foundation

public class DeleteFolderByIdQueryParams {
    /// Delete a folder that is not empty by recursively deleting the
    /// folder and all of its content.
    public let recursive: Bool?

    /// Initializer for a DeleteFolderByIdQueryParams.
    ///
    /// - Parameters:
    ///   - recursive: Delete a folder that is not empty by recursively deleting the
    ///     folder and all of its content.
    public init(recursive: Bool? = nil) {
        self.recursive = recursive
    }

}
