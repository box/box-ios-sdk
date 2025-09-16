import Foundation

public enum SignRequestCreateSignerRoleField: CodableStringEnum {
    case signer
    case approver
    case finalCopyReader
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "signer".lowercased():
            self = .signer
        case "approver".lowercased():
            self = .approver
        case "final_copy_reader".lowercased():
            self = .finalCopyReader
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .signer:
            return "signer"
        case .approver:
            return "approver"
        case .finalCopyReader:
            return "final_copy_reader"
        case .customValue(let value):
            return value
        }
    }

}
