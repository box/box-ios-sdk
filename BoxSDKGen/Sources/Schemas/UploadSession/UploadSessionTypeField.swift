import Foundation

public enum UploadSessionTypeField: CodableStringEnum {
    case uploadSession
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "upload_session".lowercased():
            self = .uploadSession
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .uploadSession:
            return "upload_session"
        case .customValue(let value):
            return value
        }
    }

}
