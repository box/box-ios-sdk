import Foundation

public class UpdateAllSkillCardsOnFileRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case status
        case metadata
        case file
        case fileVersion = "file_version"
        case usage
    }

    /// Defines the status of this invocation. Set this to `success` when setting Skill cards.
    public let status: UpdateAllSkillCardsOnFileRequestBodyStatusField

    /// The metadata to set for this skill. This is a list of
    /// Box Skills cards. These cards will overwrite any existing Box
    /// skill cards on the file.
    public let metadata: UpdateAllSkillCardsOnFileRequestBodyMetadataField

    /// The file to assign the cards to.
    public let file: UpdateAllSkillCardsOnFileRequestBodyFileField

    /// The optional file version to assign the cards to.
    public let fileVersion: UpdateAllSkillCardsOnFileRequestBodyFileVersionField?

    /// A descriptor that defines what items are affected by this call.
    /// 
    /// Set this to the default values when setting a card to a `success`
    /// state, and leave it out in most other situations.
    public let usage: UpdateAllSkillCardsOnFileRequestBodyUsageField?

    /// Initializer for a UpdateAllSkillCardsOnFileRequestBody.
    ///
    /// - Parameters:
    ///   - status: Defines the status of this invocation. Set this to `success` when setting Skill cards.
    ///   - metadata: The metadata to set for this skill. This is a list of
    ///     Box Skills cards. These cards will overwrite any existing Box
    ///     skill cards on the file.
    ///   - file: The file to assign the cards to.
    ///   - fileVersion: The optional file version to assign the cards to.
    ///   - usage: A descriptor that defines what items are affected by this call.
    ///     
    ///     Set this to the default values when setting a card to a `success`
    ///     state, and leave it out in most other situations.
    public init(status: UpdateAllSkillCardsOnFileRequestBodyStatusField, metadata: UpdateAllSkillCardsOnFileRequestBodyMetadataField, file: UpdateAllSkillCardsOnFileRequestBodyFileField, fileVersion: UpdateAllSkillCardsOnFileRequestBodyFileVersionField? = nil, usage: UpdateAllSkillCardsOnFileRequestBodyUsageField? = nil) {
        self.status = status
        self.metadata = metadata
        self.file = file
        self.fileVersion = fileVersion
        self.usage = usage
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(UpdateAllSkillCardsOnFileRequestBodyStatusField.self, forKey: .status)
        metadata = try container.decode(UpdateAllSkillCardsOnFileRequestBodyMetadataField.self, forKey: .metadata)
        file = try container.decode(UpdateAllSkillCardsOnFileRequestBodyFileField.self, forKey: .file)
        fileVersion = try container.decodeIfPresent(UpdateAllSkillCardsOnFileRequestBodyFileVersionField.self, forKey: .fileVersion)
        usage = try container.decodeIfPresent(UpdateAllSkillCardsOnFileRequestBodyUsageField.self, forKey: .usage)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(file, forKey: .file)
        try container.encodeIfPresent(fileVersion, forKey: .fileVersion)
        try container.encodeIfPresent(usage, forKey: .usage)
    }

}
