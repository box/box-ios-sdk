import Foundation

public class GetEnterpriseConfigurationByIdV2025R0QueryParams {
    /// The comma-delimited list of the enterprise configuration categories. 
    /// Allowed values: `security`, `content_and_sharing`, `user_settings`, `shield`.
    public let categories: String

    /// Initializer for a GetEnterpriseConfigurationByIdV2025R0QueryParams.
    ///
    /// - Parameters:
    ///   - categories: The comma-delimited list of the enterprise configuration categories. 
    ///     Allowed values: `security`, `content_and_sharing`, `user_settings`, `shield`.
    public init(categories: String) {
        self.categories = categories
    }

}
