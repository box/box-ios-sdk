import Foundation

public class DeleteUserByIdQueryParams {
    /// Whether the user will receive email notification of
    /// the deletion
    public let notify: Bool?

    /// Whether the user should be deleted even if this user
    /// still own files
    public let force: Bool?

    /// Initializer for a DeleteUserByIdQueryParams.
    ///
    /// - Parameters:
    ///   - notify: Whether the user will receive email notification of
    ///     the deletion
    ///   - force: Whether the user should be deleted even if this user
    ///     still own files
    public init(notify: Bool? = nil, force: Bool? = nil) {
        self.notify = notify
        self.force = force
    }

}
