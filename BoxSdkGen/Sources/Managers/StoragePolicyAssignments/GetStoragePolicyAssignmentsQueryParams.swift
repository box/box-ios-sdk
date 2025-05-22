import Foundation

public class GetStoragePolicyAssignmentsQueryParams {
    /// The target type to return assignments for
    public let resolvedForType: GetStoragePolicyAssignmentsQueryParamsResolvedForTypeField

    /// The ID of the user or enterprise to return assignments for
    public let resolvedForId: String

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// Initializer for a GetStoragePolicyAssignmentsQueryParams.
    ///
    /// - Parameters:
    ///   - resolvedForType: The target type to return assignments for
    ///   - resolvedForId: The ID of the user or enterprise to return assignments for
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    public init(resolvedForType: GetStoragePolicyAssignmentsQueryParamsResolvedForTypeField, resolvedForId: String, marker: String? = nil) {
        self.resolvedForType = resolvedForType
        self.resolvedForId = resolvedForId
        self.marker = marker
    }

}
