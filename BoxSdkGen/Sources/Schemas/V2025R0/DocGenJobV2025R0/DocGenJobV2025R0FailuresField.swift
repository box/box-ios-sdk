import Foundation

public class DocGenJobV2025R0FailuresField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case errors
        case warnings
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A list of errors that occurred during document generation.
    public let errors: [String]

    /// A list of warnings that occurred during document generation.
    public let warnings: [String]

    /// Initializer for a DocGenJobV2025R0FailuresField.
    ///
    /// - Parameters:
    ///   - errors: A list of errors that occurred during document generation.
    ///   - warnings: A list of warnings that occurred during document generation.
    public init(errors: [String], warnings: [String]) {
        self.errors = errors
        self.warnings = warnings
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errors = try container.decode([String].self, forKey: .errors)
        warnings = try container.decode([String].self, forKey: .warnings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(errors, forKey: .errors)
        try container.encode(warnings, forKey: .warnings)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
