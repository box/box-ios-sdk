import Foundation

public class DeleteUserByIdQueryParams {
    /// Whether the user will receive email notification of
    /// the deletion.
    public let notify: Bool?

    /// Specifies whether to delete the user even if they still own files,
    /// were recently active, or recently joined the enterprise from a free account.
    public let force: Bool?

    /// Initializer for a DeleteUserByIdQueryParams.
    ///
    /// - Parameters:
    ///   - notify: Whether the user will receive email notification of
    ///     the deletion.
    ///   - force: Specifies whether to delete the user even if they still own files,
    ///     were recently active, or recently joined the enterprise from a free account.
    public init(notify: Bool? = nil, force: Bool? = nil) {
        self.notify = notify
        self.force = force
    }

}
