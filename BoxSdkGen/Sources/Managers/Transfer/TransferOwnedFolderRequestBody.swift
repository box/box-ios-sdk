import Foundation

public class TransferOwnedFolderRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case ownedBy = "owned_by"
    }

    /// The user who the folder will be transferred to
    public let ownedBy: TransferOwnedFolderRequestBodyOwnedByField

    /// Initializer for a TransferOwnedFolderRequestBody.
    ///
    /// - Parameters:
    ///   - ownedBy: The user who the folder will be transferred to
    public init(ownedBy: TransferOwnedFolderRequestBodyOwnedByField) {
        self.ownedBy = ownedBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ownedBy = try container.decode(TransferOwnedFolderRequestBodyOwnedByField.self, forKey: .ownedBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ownedBy, forKey: .ownedBy)
    }

}
