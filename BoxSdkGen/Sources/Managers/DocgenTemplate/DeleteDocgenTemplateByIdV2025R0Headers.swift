import Foundation

public class DeleteDocgenTemplateByIdV2025R0Headers {
    /// Version header
    public let boxVersion: BoxVersionHeaderV2025R0

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a DeleteDocgenTemplateByIdV2025R0Headers.
    ///
    /// - Parameters:
    ///   - boxVersion: Version header
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(boxVersion: BoxVersionHeaderV2025R0 = BoxVersionHeaderV2025R0._20250, extraHeaders: [String: String?]? = [:]) {
        self.boxVersion = boxVersion
        self.extraHeaders = extraHeaders
    }

}
