import Foundation

public enum WebhookInvocationTypeField: CodableStringEnum {
    case webhookEvent
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "webhook_event".lowercased():
            self = .webhookEvent
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .webhookEvent:
            return "webhook_event"
        case .customValue(let value):
            return value
        }
    }

}
