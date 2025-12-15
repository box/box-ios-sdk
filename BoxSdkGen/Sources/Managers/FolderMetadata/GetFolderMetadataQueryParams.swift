import Foundation

public class GetFolderMetadataQueryParams {
    /// Taxonomy field values are returned in `API view` by default, meaning 
    /// the value is represented with a taxonomy node identifier. 
    /// To retrieve the `Hydrated view`, where taxonomy values are represented 
    /// with the full taxonomy node information, set this parameter to `hydrated`. 
    /// This is the only supported value for this parameter.
    public let view: String?

    /// Initializer for a GetFolderMetadataQueryParams.
    ///
    /// - Parameters:
    ///   - view: Taxonomy field values are returned in `API view` by default, meaning 
    ///     the value is represented with a taxonomy node identifier. 
    ///     To retrieve the `Hydrated view`, where taxonomy values are represented 
    ///     with the full taxonomy node information, set this parameter to `hydrated`. 
    ///     This is the only supported value for this parameter.
    public init(view: String? = nil) {
        self.view = view
    }

}
