import Foundation

public enum ZipDownloadStatusStateField: CodableStringEnum {
    case inProgress
    case failed
    case succeeded
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "in_progress".lowercased():
            self = .inProgress
        case "failed".lowercased():
            self = .failed
        case "succeeded".lowercased():
            self = .succeeded
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .inProgress:
            return "in_progress"
        case .failed:
            return "failed"
        case .succeeded:
            return "succeeded"
        case .customValue(let value):
            return value
        }
    }

}
