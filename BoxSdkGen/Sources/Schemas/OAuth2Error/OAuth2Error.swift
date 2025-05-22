import Foundation

/// An OAuth 2.0 error
public class OAuth2Error: Codable {
    private enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }

    /// The type of the error returned.
    public let error: String?

    /// The type of the error returned.
    public let errorDescription: String?

    /// Initializer for a OAuth2Error.
    ///
    /// - Parameters:
    ///   - error: The type of the error returned.
    ///   - errorDescription: The type of the error returned.
    public init(error: String? = nil, errorDescription: String? = nil) {
        self.error = error
        self.errorDescription = errorDescription
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        error = try container.decodeIfPresent(String.self, forKey: .error)
        errorDescription = try container.decodeIfPresent(String.self, forKey: .errorDescription)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(error, forKey: .error)
        try container.encodeIfPresent(errorDescription, forKey: .errorDescription)
    }

}
