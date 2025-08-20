import Foundation

public enum DocGenBatchBaseV2025R0TypeField: CodableStringEnum {
    case docgenBatch
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "docgen_batch".lowercased():
            self = .docgenBatch
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .docgenBatch:
            return "docgen_batch"
        case .customValue(let value):
            return value
        }
    }

}
