import Foundation

/// A Box Doc Gen template object.
public class DocGenTemplateV2025R0: DocGenTemplateBaseV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// The name of the template.
    @CodableTriState public private(set) var fileName: String?

    /// Initializer for a DocGenTemplateV2025R0.
    ///
    /// - Parameters:
    ///   - file: 
    ///   - fileName: The name of the template.
    public init(file: FileReferenceV2025R0? = nil, fileName: TriStateField<String> = nil) {
        self._fileName = CodableTriState(state: fileName)

        super.init(file: file)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fileName = try container.decodeIfPresent(String.self, forKey: .fileName)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _fileName.state, forKey: .fileName)
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
