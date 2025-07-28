import Foundation

public class GetTermsOfServiceQueryParams {
    /// Limits the results to the terms of service of the given type.
    public let tosType: GetTermsOfServiceQueryParamsTosTypeField?

    /// Initializer for a GetTermsOfServiceQueryParams.
    ///
    /// - Parameters:
    ///   - tosType: Limits the results to the terms of service of the given type.
    public init(tosType: GetTermsOfServiceQueryParamsTosTypeField? = nil) {
        self.tosType = tosType
    }

}
