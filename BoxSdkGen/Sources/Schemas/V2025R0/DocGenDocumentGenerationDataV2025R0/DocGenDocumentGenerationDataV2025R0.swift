import Foundation

/// The schema for for creating a Box Doc Gen job request.
public class DocGenDocumentGenerationDataV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case generatedFileName = "generated_file_name"
        case userInput = "user_input"
        case externalId = "external_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// File name of the output file.
    public let generatedFileName: String

    public let userInput: [String: AnyCodable]

    /// An optional identifier supplied by the caller for this Box Doc Gen job.
    /// The value is returned on job responses for correlation only. It is not
    /// a Box resource ID, is not required to be unique, and cannot be used to
    /// look up the job.
    public let externalId: String?

    /// Initializer for a DocGenDocumentGenerationDataV2025R0.
    ///
    /// - Parameters:
    ///   - generatedFileName: File name of the output file.
    ///   - userInput: 
    ///   - externalId: An optional identifier supplied by the caller for this Box Doc Gen job.
    ///     The value is returned on job responses for correlation only. It is not
    ///     a Box resource ID, is not required to be unique, and cannot be used to
    ///     look up the job.
    public init(generatedFileName: String, userInput: [String: AnyCodable], externalId: String? = nil) {
        self.generatedFileName = generatedFileName
        self.userInput = userInput
        self.externalId = externalId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        generatedFileName = try container.decode(String.self, forKey: .generatedFileName)
        userInput = try container.decode([String: AnyCodable].self, forKey: .userInput)
        externalId = try container.decodeIfPresent(String.self, forKey: .externalId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(generatedFileName, forKey: .generatedFileName)
        try container.encode(userInput, forKey: .userInput)
        try container.encodeIfPresent(externalId, forKey: .externalId)
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
