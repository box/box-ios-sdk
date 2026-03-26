import Foundation

public enum HubDocumentBlocksV2025R0TypeField: CodableStringEnum {
    case documentBlocks
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "document_blocks".lowercased():
            self = .documentBlocks
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .documentBlocks:
            return "document_blocks"
        case .customValue(let value):
            return value
        }
    }

}
