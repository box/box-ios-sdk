import Foundation

public class GetFileByIdHeaders {
    /// Ensures an item is only returned if it has changed.
    /// 
    /// Pass in the item's last observed `etag` value
    /// into this header and the endpoint will fail
    /// with a `304 Not Modified` if the item has not
    /// changed since.
    public let ifNoneMatch: String?

    /// The URL, and optional password, for the shared link of this item.
    /// 
    /// This header can be used to access items that have not been
    /// explicitly shared with a user.
    /// 
    /// Use the format `shared_link=[link]` or if a password is required then
    /// use `shared_link=[link]&shared_link_password=[password]`.
    /// 
    /// This header can be used on the file or folder shared, as well as on any files
    /// or folders nested within the item.
    public let boxapi: String?

    /// A header required to request specific `representations`
    /// of a file. Use this in combination with the `fields` query
    /// parameter to request a specific file representation.
    /// 
    /// The general format for these representations is
    /// `X-Rep-Hints: [...]` where `[...]` is one or many
    /// hints in the format `[fileType?query]`.
    /// 
    /// For example, to request a `png` representation in `32x32`
    /// as well as `64x64` pixel dimensions provide the following
    /// hints.
    /// 
    /// `x-rep-hints: [jpg?dimensions=32x32][jpg?dimensions=64x64]`
    /// 
    /// Additionally, a `text` representation is available for all
    /// document file types in Box using the `[extracted_text]`
    /// representation.
    /// 
    /// `x-rep-hints: [extracted_text]`
    public let xRepHints: String?

    /// Extra headers that will be included in the HTTP request.
    public let extraHeaders: [String: String?]?

    /// Initializer for a GetFileByIdHeaders.
    ///
    /// - Parameters:
    ///   - ifNoneMatch: Ensures an item is only returned if it has changed.
    ///     
    ///     Pass in the item's last observed `etag` value
    ///     into this header and the endpoint will fail
    ///     with a `304 Not Modified` if the item has not
    ///     changed since.
    ///   - boxapi: The URL, and optional password, for the shared link of this item.
    ///     
    ///     This header can be used to access items that have not been
    ///     explicitly shared with a user.
    ///     
    ///     Use the format `shared_link=[link]` or if a password is required then
    ///     use `shared_link=[link]&shared_link_password=[password]`.
    ///     
    ///     This header can be used on the file or folder shared, as well as on any files
    ///     or folders nested within the item.
    ///   - xRepHints: A header required to request specific `representations`
    ///     of a file. Use this in combination with the `fields` query
    ///     parameter to request a specific file representation.
    ///     
    ///     The general format for these representations is
    ///     `X-Rep-Hints: [...]` where `[...]` is one or many
    ///     hints in the format `[fileType?query]`.
    ///     
    ///     For example, to request a `png` representation in `32x32`
    ///     as well as `64x64` pixel dimensions provide the following
    ///     hints.
    ///     
    ///     `x-rep-hints: [jpg?dimensions=32x32][jpg?dimensions=64x64]`
    ///     
    ///     Additionally, a `text` representation is available for all
    ///     document file types in Box using the `[extracted_text]`
    ///     representation.
    ///     
    ///     `x-rep-hints: [extracted_text]`
    ///   - extraHeaders: Extra headers that will be included in the HTTP request.
    public init(ifNoneMatch: String? = nil, boxapi: String? = nil, xRepHints: String? = nil, extraHeaders: [String: String?]? = [:]) {
        self.ifNoneMatch = ifNoneMatch
        self.boxapi = boxapi
        self.xRepHints = xRepHints
        self.extraHeaders = extraHeaders
    }

}
