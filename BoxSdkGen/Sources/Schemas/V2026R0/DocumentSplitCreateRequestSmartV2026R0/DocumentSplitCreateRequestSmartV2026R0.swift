import Foundation

/// Validation rules for creating a Document Split job using Box-generated page
/// ranges guided by a caller-supplied prompt.
public class DocumentSplitCreateRequestSmartV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case prompt
        case splitType = "split_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A natural language prompt that guides automatic page range detection.
    public let prompt: String

    /// Discriminator. Must be `smart` for this variant.
    public let splitType: DocumentSplitCreateRequestSmartV2026R0SplitTypeField

    /// Initializer for a DocumentSplitCreateRequestSmartV2026R0.
    ///
    /// - Parameters:
    ///   - prompt: A natural language prompt that guides automatic page range detection.
    ///   - splitType: Discriminator. Must be `smart` for this variant.
    public init(prompt: String, splitType: DocumentSplitCreateRequestSmartV2026R0SplitTypeField = DocumentSplitCreateRequestSmartV2026R0SplitTypeField.smart) {
        self.prompt = prompt
        self.splitType = splitType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try container.decode(String.self, forKey: .prompt)
        splitType = try container.decode(DocumentSplitCreateRequestSmartV2026R0SplitTypeField.self, forKey: .splitType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(splitType, forKey: .splitType)
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
