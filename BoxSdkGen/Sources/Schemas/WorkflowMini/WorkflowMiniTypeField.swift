import Foundation

public enum WorkflowMiniTypeField: CodableStringEnum {
    case workflow
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "workflow".lowercased():
            self = .workflow
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .workflow:
            return "workflow"
        case .customValue(let value):
            return value
        }
    }

}
