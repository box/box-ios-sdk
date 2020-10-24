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
    private var _nextPage: PagingParameter?
    private var isDone: Bool
    private var isStreamEmpty: Bool

    private let url: URL
    private let headers: BoxHTTPHeaders
    private var queryParams: QueryParameters

    private var dispatchQueue: DispatchQueue
    private var nextPageQueue: [Callback<EntryContainer<Element>>] = []

    /// The total count of the result set, if known
    public private(set) var totalCount: Int?

    init(client: BoxClient, url: URL, headers: BoxHTTPHeaders, queryParams: QueryParameters) {
        self.client = client
        self.url = url
        self.headers = headers.filter { $0.key.lowercased() != "authorization" }
        self.queryParams = queryParams

        isDone = false
        isStreamEmpty = false

        dispatchQueue = DispatchQueue(label: "com.box.swiftsdk.pagingiterator", qos: .userInitiated)
    }

    /// Initializer
    ///
    /// - Parameters:
    ///   - response: A BoxResponse from the API. The iterator is initialized from the data in the response.
    ///   - client: A BoxClient that will be used for any API calls the iterator makes internally in order to get more data.
    convenience init(response: BoxResponse, client: BoxClient) throws {
        let result: Result<EntryContainer<Element>, BoxSDKError> = ObjectDeserializer.deserialize(data: response.body)

        switch result {
        case let .success(page):
            self.init(
                client: client,
                url: response.request.url,
                headers: response.request.httpHeaders,
                queryParams: response.request.queryParams
            )
            totalCount = page.totalCount
            updatePaging(page: page)

        case let .failure(error):
            throw error
        }
    }

    /// Update internal paging parameters to be used for the next API call
    private func updatePaging(page: EntryContainer<Element>) {
        if let previousOffset = page.offset {
            let limit = page.limit ?? page.entries.count
            _nextPage = .offset(previousOffset + limit)
            if page.totalCount != nil {
                isDone = page.offset! + limit > page.totalCount!
            }
            else {
                isDone = page.entries.isEmpty
            }
        }
        else if let nextStreamPosition = page.nextStreamPosition {
            if page.entries.isEmpty {
                isStreamEmpty = true
            }
            _nextPage = .streamPosition(nextStreamPosition)
        }
        else if let nextPageMarker = page.nextMarker {
            _nextPage = .marker(nextPageMarker)
        }
        else {
            // Default to a finished marker collection when there's no field present,
            // since some endpoints indicate completed paging this way
            _nextPage = .marker(nil)
            isDone = true
        }

        queryParams = queryParams.merging(_nextPage!.asQueryParams) { _, right in right }
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
        self.client.get(
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
