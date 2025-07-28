import Foundation

public class GetAiAgentByIdQueryParams {
    /// The fields to return in the response.
    public let fields: [String]?

    /// Initializer for a GetAiAgentByIdQueryParams.
    ///
    /// - Parameters:
    ///   - fields: The fields to return in the response.
    public init(fields: [String]? = nil) {
        self.fields = fields
    }

}
