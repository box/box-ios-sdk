import Foundation

public enum HubSectionTitleTextBlockV2025R0TypeField: CodableStringEnum {
    case sectionTitle
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "section_title".lowercased():
            self = .sectionTitle
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .sectionTitle:
            return "section_title"
        case .customValue(let value):
            return value
        }
    }

}
