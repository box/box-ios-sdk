import Foundation

public class UploadSessionSessionEndpointsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case uploadPart = "upload_part"
        case commit
        case abort
        case listParts = "list_parts"
        case status
        case logEvent = "log_event"
    }

    /// The URL to upload parts to
    public let uploadPart: String?

    /// The URL used to commit the file
    public let commit: String?

    /// The URL for used to abort the session.
    public let abort: String?

    /// The URL users to list all parts.
    public let listParts: String?

    /// The URL used to get the status of the upload.
    public let status: String?

    /// The URL used to get the upload log from.
    public let logEvent: String?

    /// Initializer for a UploadSessionSessionEndpointsField.
    ///
    /// - Parameters:
    ///   - uploadPart: The URL to upload parts to
    ///   - commit: The URL used to commit the file
    ///   - abort: The URL for used to abort the session.
    ///   - listParts: The URL users to list all parts.
    ///   - status: The URL used to get the status of the upload.
    ///   - logEvent: The URL used to get the upload log from.
    public init(uploadPart: String? = nil, commit: String? = nil, abort: String? = nil, listParts: String? = nil, status: String? = nil, logEvent: String? = nil) {
        self.uploadPart = uploadPart
        self.commit = commit
        self.abort = abort
        self.listParts = listParts
        self.status = status
        self.logEvent = logEvent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uploadPart = try container.decodeIfPresent(String.self, forKey: .uploadPart)
        commit = try container.decodeIfPresent(String.self, forKey: .commit)
        abort = try container.decodeIfPresent(String.self, forKey: .abort)
        listParts = try container.decodeIfPresent(String.self, forKey: .listParts)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        logEvent = try container.decodeIfPresent(String.self, forKey: .logEvent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(uploadPart, forKey: .uploadPart)
        try container.encodeIfPresent(commit, forKey: .commit)
        try container.encodeIfPresent(abort, forKey: .abort)
        try container.encodeIfPresent(listParts, forKey: .listParts)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(logEvent, forKey: .logEvent)
    }

}
