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

/// Provides paged iterator access for a collection of BoxModel's
public class PagingIterator<Element: BoxModel> {

    private let client: BoxClient

    /// Gets offset, marker or stream position for the next page
    private var nextPage: PagingParameter?
    private var isDone: Bool
    private var isStreamEmpty: Bool

    private let url: URL
    private let headers: BoxHTTPHeaders
    private var queryParams: QueryParameters

    private var dispatchQueue: DispatchQueue
    private var nextPageQueue: [Callback<EntryContainer<Element>>] = []

    /// The total count of the result set, if known
    public private(set) var totalCount: Int?

    /// Initializer
    ///
    /// - Parameters:
    ///   - client: A BoxClient that will be used for any API calls the iterator makes internally in order to get more data.
    ///   - url: The endpoint from which to get pages, using HTTP GET.
    ///   - queryParams: The query parameters for the initial page. Paging parameters are updated for subsequent pages.
    ///   - headers: The HTTP headers to send with each request (authorization is handled by the client).
    init(client: BoxClient, url: URL, queryParameters: QueryParameters, headers: BoxHTTPHeaders = [:]) {
        self.client = client
        self.url = url
        self.headers = headers.filter { $0.key.lowercased() != "authorization" }
        queryParams = queryParameters

        isDone = false
        isStreamEmpty = false

        dispatchQueue = DispatchQueue(label: "com.box.swiftsdk.pagingiterator", qos: .userInitiated)
    }

    /// Update internal paging parameters to be used for the next API call
    private func updatePaging(page: EntryContainer<Element>) {
        // Update total count if available
        if let totalCountFromPage = page.totalCount {
            totalCount = totalCountFromPage
        }

        // Handle offset-based paging
        if let previousOffset = page.offset {
            let limit = page.limit ?? page.entries.count
            nextPage = .offset(previousOffset + limit)
            if let totalCount = totalCount {
                isDone = previousOffset + limit >= totalCount
            }
            else {
                isDone = page.entries.isEmpty
            }
        }
        // Handle stream position paging
        else if let nextStreamPosition = page.nextStreamPosition {
            if page.entries.isEmpty {
                isStreamEmpty = true
            }
            nextPage = .streamPosition(nextStreamPosition)
        }
        // Handle marker based paging
        // An Empty string, like a nil `nextMarker`, indicates the end has been reached.
        // ref: https://developer.box.com/guides/api-calls/pagination/marker-based/
        else if let nextPageMarker = page.nextMarker, !nextPageMarker.isEmpty {
            nextPage = .marker(nextPageMarker)
        }
        // Handle unexpected value with no paging information
        else {
            // Default to a finished marker collection when there's no field present,
            // since some endpoints indicate completed paging this way
            nextPage = .marker(nil)
            isDone = true
        }

        if let updatedParams = nextPage?.asQueryParams {
            queryParams = queryParams.merging(updatedParams) { _, right in right }
        }
    }

    /// Gets next page of elements from the iterator
    ///
    /// - Parameter completion: Returns either the next page of elements or an error.
    ///             If the iterator has no more elements, a BoxSDKError with a
    ///             message of BoxSDKErrorEnum.endOfList is passed to the completion.
    public func next(completion: @escaping Callback<EntryContainer<Element>>) {
        dispatchQueue.async {
            // 1. Return end-failure if iterator is done
            if self.isDone {
                completion(.failure(BoxSDKError(message: .endOfList)))
                return
            }

            // 2. If a completion queue is already set up, that means another page of results
            // is already on its way; we can just wait for it to arrive by adding this completion
            // to the completion queue
            guard self.nextPageQueue.isEmpty else {
                self.nextPageQueue.append(completion)
                return
            }

            // 3. There are no more results in the buffer and we need to request more from the API
            // 3a. Set up the completion queue and insert this completion as the first item,
            // so subsequent requests can queue behind this one
            self.nextPageQueue = [completion]

            // 3b. Get the next page of results from the API and load them into the buffer
            self.getData()
        }
    }

    /// Get the next page of items from the API
    private func getData() {
        client.get(
            url: url,
            httpHeaders: headers,
            queryParameters: queryParams
        ) { result in

            // Add an item on the dispatch queue to process the new page of results; this guarantees
            // that any previous calls to next() have already been added to the completion queue
            self.dispatchQueue.async {
                let pageResult: Result<EntryContainer<Element>, BoxSDKError> = result.flatMap {
                    ObjectDeserializer.deserialize(data: $0.body)
                }

                let queuedCompletion = self.nextPageQueue.removeFirst()
                queuedCompletion(pageResult)

                switch pageResult {
                case let .success(page):
                    // Update paging parameters for next API call
                    self.updatePaging(page: page)

                    if self.isDone || self.isStreamEmpty {
                        for queuedCompletion in self.nextPageQueue {
                            queuedCompletion(.failure(BoxSDKError(message: .endOfList)))
                        }
                        self.nextPageQueue = []
                        return
                    }

                    if !self.nextPageQueue.isEmpty {
                        self.getData()
                        return
                    }

                case let .failure(error):
                    // If an API call fails completely, pass the error to all waiting completions
                    for queuedCompletion in self.nextPageQueue {
                        queuedCompletion(.failure(error))
                    }

                    // Clear the completion queue so future calls to next() can retry
                    self.nextPageQueue = []
                }
            }
        }
    }
}
