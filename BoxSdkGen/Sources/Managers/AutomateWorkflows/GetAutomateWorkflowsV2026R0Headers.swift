import Foundation

public class GetAutomateWorkflowsV2026R0Headers {
    /// Version header.
    public let boxVersion: BoxVersionHeaderV2026R0

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a GetAutomateWorkflowsV2026R0Headers.
    ///
    /// - Parameters:
    ///   - boxVersion: Version header.
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(boxVersion: BoxVersionHeaderV2026R0 = BoxVersionHeaderV2026R0._20260, extraHeaders: [String: String?]? = [:]) {
        self.boxVersion = boxVersion
        self.extraHeaders = extraHeaders
    }

}
