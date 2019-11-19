import Foundation

/// Files, folders, or web links contained within a folder.
public enum FolderItem: BoxModel {
    // MARK: - BoxModel

    public var rawData: [String: Any] {
        switch self {
        case let .file(file):
            return file.rawData
        case let .folder(folder):
            return folder.rawData
        case let .webLink(webLink):
            return webLink.rawData
        }
    }

    /// Folder type
    case folder(Folder)
    /// File type
    case file(File)
    /// Weblink type pointing to either a file or folder.
    case webLink(WebLink)

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public init(json: [String: Any]) throws {
        guard let type = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }
        switch type {
        case "file":
            let file = try File(json: json)
            self = .file(file)
        case "folder":
            let folder = try Folder(json: json)
            self = .folder(folder)
        case "web_link":
            let webLink = try WebLink(json: json)
            self = .webLink(webLink)
        default:
            throw BoxCodingError(message: .valueMismatch(key: "type", value: type, acceptedValues: ["file", "folder", "web_link"]))
        }
    }
}

extension FolderItem: CustomDebugStringConvertible {

    /// Item debug description.
    public var debugDescription: String {
        switch self {
        case let .folder(folder):
            return "folder \(String(describing: folder.name))"
        case let .file(file):
            return "file \(String(describing: file.name))"
        case let .webLink(webLink):
            return "web link \(String(describing: webLink.name))"
        }
    }
}
