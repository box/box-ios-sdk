import Foundation

/// Search result from the content search endpoint.
public enum SearchResultsResponse: Codable {
    case searchResults(SearchResults)
    case searchResultsWithSharedLinks(SearchResultsWithSharedLinks)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "search_results_items":
                    if let content = try? SearchResults(from: decoder) {
                        self = .searchResults(content)
                        return
                    }

                case "search_results_with_shared_links":
                    if let content = try? SearchResultsWithSharedLinks(from: decoder) {
                        self = .searchResultsWithSharedLinks(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(SearchResultsResponse.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .searchResults(let searchResults):
            try searchResults.encode(to: encoder)
        case .searchResultsWithSharedLinks(let searchResultsWithSharedLinks):
            try searchResultsWithSharedLinks.encode(to: encoder)
        }
    }

}
