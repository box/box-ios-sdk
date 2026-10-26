import Foundation

public enum ShuttleDiscoveredSubjectV2026R0TypeField: CodableStringEnum {
    case shuttleDiscoveredSubject
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_discovered_subject".lowercased():
            self = .shuttleDiscoveredSubject
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttleDiscoveredSubject:
            return "shuttle_discovered_subject"
        case .customValue(let value):
            return value
        }
    }

}
