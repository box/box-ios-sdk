import Foundation

public class GetFileByIdQueryParams {
    /// A comma-separated list of attributes to include in the
    /// response. This can be used to request fields that are
    /// not normally returned in a standard response.
    /// 
    /// Be aware that specifying this parameter will have the
    /// effect that none of the standard fields are returned in
    /// the response unless explicitly specified, instead only
    /// fields for the mini representation are returned, additional
    /// to the fields requested.
    /// 
    /// Additionally this field can be used to query any metadata
    /// applied to the file by specifying the `metadata` field as well
    /// as the scope and key of the template to retrieve, for example
    /// `?fields=metadata.enterprise_12345.contractTemplate`.
    public let fields: [String]?

    /// Initializer for a GetFileByIdQueryParams.
    ///
    /// - Parameters:
    ///   - fields: A comma-separated list of attributes to include in the
    ///     response. This can be used to request fields that are
    ///     not normally returned in a standard response.
    ///     
    ///     Be aware that specifying this parameter will have the
    ///     effect that none of the standard fields are returned in
    ///     the response unless explicitly specified, instead only
    ///     fields for the mini representation are returned, additional
    ///     to the fields requested.
    ///     
    ///     Additionally this field can be used to query any metadata
    ///     applied to the file by specifying the `metadata` field as well
    ///     as the scope and key of the template to retrieve, for example
    ///     `?fields=metadata.enterprise_12345.contractTemplate`.
    public init(fields: [String]? = nil) {
        self.fields = fields
    }

}
