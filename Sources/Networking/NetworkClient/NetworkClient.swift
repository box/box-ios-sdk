import Foundation

public protocol NetworkClient {
    func fetch(options: FetchOptions) async throws -> FetchResponse

}
