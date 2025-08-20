import Foundation

public enum UpdateFileByIdRequestBodyLockAccessField: CodableStringEnum {
    case lock
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "lock".lowercased():
            self = .lock
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .lock:
            return "lock"
        case .customValue(let value):
            return value
        }
    }

}
