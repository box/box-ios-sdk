import Foundation

public enum HubDocumentPagesV2025R0TypeField: CodableStringEnum {
    case documentPages
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "document_pages".lowercased():
            self = .documentPages
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .documentPages:
            return "document_pages"
        case .customValue(let value):
            return value
        }
    }

}
