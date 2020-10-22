//
//  PagingIterator.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer, Albert Wu.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Stores offset, marker or stream position for the iterator
public enum PagingParameter {
    /// Offset
    case offset(Int)
    /// Marker
    case marker(String?)
    /// Stream position
    case streamPosition(String?)

    var asQueryParams: QueryParameters {
        switch self {
        case let .offset(offset):
            return ["offset": offset]
        case let .marker(marker):
            return ["marker": marker]
        case let .streamPosition(streamPosition):
            return ["stream_position": streamPosition]
        }
    }
}

/// Gets pages from a paged API
public class AsyncPagesIterator<Element: BoxModel> {

    /// The type of the page sent to callbacks registered with the `next` method
    public typealias Page = EntryContainer<Element>

    private let client: BoxClient

    /// Gets offset, marker or stream position for the next page after the
    /// initial page is received
    private var nextPage: PagingParameter?
    fileprivate var isDone: Bool // swiftlint:disable:this strict_fileprivate
    fileprivate var isStreamEmpty: Bool // swiftlint:disable:this strict_fileprivate

    private let url: URL
    private let headers: BoxHTTPHeaders
    private var queryParams: QueryParameters

    let dispatchQueue: DispatchQueue
    private var pageCallbacks: [Callback<Page>]

    /// Initializer
    ///
    /// - Parameters:
    ///   - client: A BoxClient that will be used for any API calls the iterator makes internally in order to get more data.
    ///   - request: A BoxRequest representing the first page request.
    init(client: BoxClient, url: URL, headers: BoxHTTPHeaders, queryParams: QueryParameters) {
        self.client = client
        self.url = url
        self.headers = headers.filter { $0.key.lowercased() != "authorization" }
        self.queryParams = queryParams

        isDone = false
        isStreamEmpty = false

        dispatchQueue = DispatchQueue(label: "com.box.swiftsdk.asyncpagesiterator", qos: .userInitiated)
        pageCallbacks = []
    }

    /// Gets next element from the iterator
    ///
    /// - Parameter completion: Returns either the next page or an error.
    ///             If the iterator has no more elements, a BoxSDKError with a
    ///             message of BoxSDKErrorEnum.endOfList is passed to the completion.
    public func next(completion: @escaping Callback<Page>) {
        // Access to private variables is protected by a serial queue
        dispatchQueue.async {
            // Return end-failure if iterator is done (this won't happen for streams)
            if self.isDone {
                completion(.failure(BoxSDKError(message: .endOfList)))
                return
            }

            // If a callback is already enqueued, that means another page of results
            // is already on its way
            let dataInFlight = !self.pageCallbacks.isEmpty
            // Either way, enqueue this block
            self.pageCallbacks.append(completion)

            // Get the next page of results from the API if no data was already in flight
            // Otherwise this will be done once the response to current request comes back
            if !dataInFlight {
                self.getData()
            }
        }
    }

    /// Update internal paging parameters to be used for the next API call.
    /// This should only be called on dispatchQueue.
    // swiftlint:disable:next strict_fileprivate
    fileprivate func prepareForPageRequest(after page: EntryContainer<Element>) {
        if let previousOffset = page.offset {
            let limit = page.limit ?? page.entries.count
            nextPage = .offset(previousOffset)

            if let totalCount = page.totalCount {
                isDone = previousOffset + limit >= totalCount
            }
            else {
                isDone = page.entries.isEmpty
            }
        }
        else if let nextStreamPosition = page.nextStreamPosition {
            nextPage = .streamPosition(nextStreamPosition)
            isStreamEmpty = page.entries.isEmpty
        }
        else if let nextMarker = page.nextMarker {
            nextPage = .marker(nextMarker)
        }
        else {
            // Default to a finished marker collection when there's no field present,
            // since some endpoints indicate completed paging this way.
            // This value should never be used.
            nextPage = .marker(nil)
            isDone = true
        }

        if !isDone {
            // swiftlint:disable:next force_unwrapping
            queryParams = queryParams.merging(nextPage!.asQueryParams) { _, right in right }
        }
    }

    /// Get the next page of items from the API
    private func getData() {
        client.get(
            url: url,
            httpHeaders: headers,
            queryParameters: queryParams
        ) { result in

            let pageResult: Result<EntryContainer<Element>, BoxSDKError> = result.flatMap {
                ObjectDeserializer.deserialize(data: $0.body)
            }

            // Access to private variables is protected by a serial queue
            self.dispatchQueue.async {
                // Get the callback associated with this request
                let callback = self.pageCallbacks.removeFirst()
                // Return the page
                callback(pageResult)

                var error: BoxSDKError?

                switch pageResult {
                case let .success(page):
                    // Update paging parameters for next API call
                    self.prepareForPageRequest(after: page)
                    // If we're at the last page it's an error for all waiting callbacks
                    if self.isDone || self.isStreamEmpty {
                        error = BoxSDKError(message: .endOfList)
                    }

                case let .failure(apiError):
                    error = apiError
                }

                // An error manifests for all waiting callbacks, rather than
                // making more page requests
                if let error = error {
                    for waiting in self.pageCallbacks {
                        waiting(.failure(error))
                    }
                    self.pageCallbacks.removeAll()
                }
                // But if there's no error, and we're waiting for more pages,
                // make a new request
                else if !self.pageCallbacks.isEmpty {
                    self.getData()
                }
            }
        }
    }
}

/// Provides paged iterator access for a collection of BoxModel's
public class PagingIterator<Element: BoxModel> {
    private let pages: AsyncPagesIterator<Element>

    private var buffer: Buffer<Element>
    private var completionQueue: [Callback<Element>]

    /// The total count of the result set, if known
    public let totalCount: Int?

    /// Initializer
    ///
    /// - Parameters:
    ///   - response: A BoxResponse from the API. The iterator is initialized from the data in the response.
    ///   - client: A BoxClient that will be used for any API calls the iterator makes internally in order to get more data.
    init(response: BoxResponse, client: BoxClient) throws {
        if !PagingIterator.isIterable(response: response) {
            throw BoxSDKError(message: .nonIterableResponse)
        }

        let result: Result<EntryContainer<Element>, BoxSDKError> = ObjectDeserializer.deserialize(data: response.body)
        switch result {
        case let .success(page):
            pages = AsyncPagesIterator<Element>(
                client: client,
                url: response.request.url,
                headers: response.request.httpHeaders,
                queryParams: response.request.queryParams
            )
            pages.prepareForPageRequest(after: page)

            totalCount = page.totalCount
            buffer = Buffer(page.entries)
            completionQueue = []

        case let .failure(error):
            throw error
        }
    }

    /// Gets next element from the iterator
    ///
    /// - Parameter completion: Returns either the next element or an error.
    ///             If the iterator has no more elements, a BoxSDKError with a
    ///             message of BoxSDKErrorEnum.noSuchElement is passed to the completion.
    public func next(completion: @escaping Callback<Element>) {
        // Protect access to private variables
        pages.dispatchQueue.async {
            // 1. Return buffered results, if there are any
            guard self.buffer.isEmpty else {
                let element = self.buffer.removeFromHead()
                completion(.success(element))
                return
            }

            // 2. If a completion queue is already set up, that means another page of results
            // is already on its way; we can just wait for it to arrive by adding this completion
            // to the completion queue
            guard self.completionQueue.isEmpty else {
                self.completionQueue.append(completion)
                return
            }

            // 3. There are no more results in the buffer and we need to request more from the API
            // 3a. Set up the completion queue and insert this completion as the first item,
            // so subsequent requests can queue behind this one
            self.completionQueue = [completion]

            // 3b. Get the next page of results from the API and load them into the buffer
            self.getData()
        }
    }

    private func getData() {
        pages.next { result in
            switch result {
            case let .success(page):
                self.buffer = Buffer(page.entries)
                while !self.completionQueue.isEmpty {
                    if self.buffer.isEmpty {
                        if self.pages.isDone || self.pages.isStreamEmpty {
                            for queuedCompletion in self.completionQueue {
                                queuedCompletion(.failure(BoxSDKError(message: .endOfList)))
                            }
                            self.completionQueue = []
                        }
                        else {
                            self.getData()
                        }
                    }

                    let queuedCompletion = self.completionQueue.removeFirst()
                    queuedCompletion(.success(self.buffer.removeFromHead()))
                }
            case let .failure(error):
                for queuedCompletion in self.completionQueue {
                    queuedCompletion(.failure(error))
                }
                self.completionQueue = []
            }
        }
    }

    static func isIterable(response: BoxResponse) -> Bool {
        guard response.request.httpMethod == .get else {
            return false
        }
        guard let responseBody = response.body else {
            return false
        }

        let responseJSON = try? JSONSerialization.jsonObject(with: responseBody, options: []) as? [String: Any]
        guard let jsonDict = responseJSON else {
            return false
        }

        guard (jsonDict["entries"] as? [Any]) != nil else {
            return false
        }

        return true
    }

    // swiftlint:enable force_unwrapping
}

/// An ordered buffer of elements that provides constant-time removal of elements from the head of the buffer.
/// Uses constant space.
private class Buffer<Element> {

    // Removing from front of array is O(n), so maintain a private index
    // into buffer for the next element to return.
    // Reset buffer and index when needed.
    var buffer: [Element]
    var bufferIndex: Int

    init(_ elems: [Element] = []) {
        buffer = elems
        bufferIndex = 0
    }

    var isEmpty: Bool {
        buffer.isEmpty || bufferIndex >= buffer.count
    }

    func removeFromHead() -> Element {
        let element = buffer[bufferIndex]
        bufferIndex += 1

        if isEmpty {
            // Reset internal state because the buffer appears empty
            buffer = []
            bufferIndex = 0
        }

        return element
    }
}
