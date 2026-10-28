import Foundation

/// Errors and warnings that occurred during a Document Split job.
public class DocumentSplitFailuresV2026R0: DocumentFailuresV2026R0 {
    private enum CodingKeys: CodingKey {
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// Initializer for a DocumentSplitFailuresV2026R0.
    ///
    /// - Parameters:
    ///   - errors: A list of errors that occurred during the document job.
    ///   - warnings: A list of warnings that occurred during the document job.
    public override init(errors: [String], warnings: [String]) {
        super.init(errors: errors, warnings: warnings)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
