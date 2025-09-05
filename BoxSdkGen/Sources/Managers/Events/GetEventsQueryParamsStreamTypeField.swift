import Foundation

public enum GetEventsQueryParamsStreamTypeField: CodableStringEnum {
    case all
    case changes
    case sync
    case adminLogs
    case adminLogsStreaming
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "all".lowercased():
            self = .all
        case "changes".lowercased():
            self = .changes
        case "sync".lowercased():
            self = .sync
        case "admin_logs".lowercased():
            self = .adminLogs
        case "admin_logs_streaming".lowercased():
            self = .adminLogsStreaming
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .all:
            return "all"
        case .changes:
            return "changes"
        case .sync:
            return "sync"
        case .adminLogs:
            return "admin_logs"
        case .adminLogsStreaming:
            return "admin_logs_streaming"
        case .customValue(let value):
            return value
        }
    }

}
