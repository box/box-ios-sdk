import Foundation

/// The error that occurs when a file can not be created due
/// to a conflict.
public class ConflictError: ClientError {
    /// Initializer for a ConflictError.
    ///
    /// - Parameters:
    ///   - type: error
    ///   - status: The HTTP status of the response.
    ///   - code: A Box-specific error code
    ///   - message: A short message describing the error.
    ///   - contextInfo: A free-form object that contains additional context
    ///     about the error. The possible fields are defined on
    ///     a per-endpoint basis. `message` is only one example.
    ///   - helpUrl: A URL that links to more information about why this error occurred.
    ///   - requestId: A unique identifier for this response, which can be used
    ///     when contacting Box support.
    public override init(type: ClientErrorTypeField? = nil, status: Int? = nil, code: ClientErrorCodeField? = nil, message: String? = nil, contextInfo: TriStateField<[String: AnyCodable]> = nil, helpUrl: String? = nil, requestId: String? = nil) {
        super.init(type: type, status: status, code: code, message: message, contextInfo: contextInfo, helpUrl: helpUrl, requestId: requestId)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

}
