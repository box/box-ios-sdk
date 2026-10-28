import Foundation

public class DeleteUserByIdQueryParams {
    /// Whether the user will receive email notification of
    /// the deletion.
    public let notify: Bool?

    /// Specifies whether to delete the user even if they still own files.
    /// 
    /// If the user owns content and the enterprise has a retention policy,
    /// including a retired one, or a legal hold that is not fully released,
    /// setting `force` to `true` doesn't delete the user. The request returns
    /// a `403` error, and you must transfer the user's content before deleting
    /// the user.
    public let force: Bool?

    /// Initializer for a DeleteUserByIdQueryParams.
    ///
    /// - Parameters:
    ///   - notify: Whether the user will receive email notification of
    ///     the deletion.
    ///   - force: Specifies whether to delete the user even if they still own files.
    ///     
    ///     If the user owns content and the enterprise has a retention policy,
    ///     including a retired one, or a legal hold that is not fully released,
    ///     setting `force` to `true` doesn't delete the user. The request returns
    ///     a `403` error, and you must transfer the user's content before deleting
    ///     the user.
    public init(notify: Bool? = nil, force: Bool? = nil) {
        self.notify = notify
        self.force = force
    }

}
