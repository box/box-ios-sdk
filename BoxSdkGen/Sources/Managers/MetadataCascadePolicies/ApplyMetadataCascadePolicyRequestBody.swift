import Foundation

public class ApplyMetadataCascadePolicyRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case conflictResolution = "conflict_resolution"
    }

    /// Describes the desired behavior when dealing with the conflict
    /// where a metadata template already has an instance applied
    /// to a child.
    /// 
    /// * `none` will preserve the existing value on the file
    /// * `overwrite` will force-apply the templates values over
    ///   any existing values.
    public let conflictResolution: ApplyMetadataCascadePolicyRequestBodyConflictResolutionField

    /// Initializer for a ApplyMetadataCascadePolicyRequestBody.
    ///
    /// - Parameters:
    ///   - conflictResolution: Describes the desired behavior when dealing with the conflict
    ///     where a metadata template already has an instance applied
    ///     to a child.
    ///     
    ///     * `none` will preserve the existing value on the file
    ///     * `overwrite` will force-apply the templates values over
    ///       any existing values.
    public init(conflictResolution: ApplyMetadataCascadePolicyRequestBodyConflictResolutionField) {
        self.conflictResolution = conflictResolution
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conflictResolution = try container.decode(ApplyMetadataCascadePolicyRequestBodyConflictResolutionField.self, forKey: .conflictResolution)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(conflictResolution, forKey: .conflictResolution)
    }

}
