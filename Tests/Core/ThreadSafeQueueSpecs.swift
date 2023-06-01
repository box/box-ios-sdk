//
//  ThreadSafeQueueSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 16/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import Quick

class ThreadSafeQueueSpecs: QuickSpec {

    override class func spec() {
        var sut: ThreadSafeQueue<Int>!

        describe("ThreadSafeQueueSpecs") {

            beforeEach {
                sut = ThreadSafeQueue(completionQueue: DispatchQueue(label: "com.box.swiftsdk.threadsafequeue.test", qos: .utility))
            }

            context("enqueue()") {
                it("should add item in order of execution") {
                    var orderedCompletionResult: [Int] = []

                    sut.enqueue(1) {
                        orderedCompletionResult.append(1)
                    }

                    sut.enqueue(2) {
                        orderedCompletionResult.append(2)
                    }

                    expect(orderedCompletionResult).toEventually(equal([1, 2]), timeout: .seconds(5))
                }
            }

            context("dequeue()") {
                it("should pass nil to completion clousure if queue is empty") {
                    var orderedCompletionResult: [Int?] = []

                    sut.dequeue { result in
                        orderedCompletionResult.append(result)
                    }

                    expect(orderedCompletionResult).toEventually(equal([nil]), timeout: .seconds(2))
                }

                it("should be executed in the same order as enqueue elements") {
                    var orderedCompletionResult: [Int?] = []

                    sut.enqueue(1) {
                        orderedCompletionResult.append(1)
                    }

                    sut.enqueue(2) {
                        orderedCompletionResult.append(2)
                    }

                    sut.dequeue { result in
                        orderedCompletionResult.append(result)
                    }

                    sut.dequeue { result in
                        orderedCompletionResult.append(result)
                    }

                    expect(orderedCompletionResult).toEventually(equal([1, 2, 1, 2]), timeout: .seconds(3))
                }
            }

            context("peek()") {
                it("should return first item added to queue if queue is not empty") {
                    var peekCompletionResult: Int?

                    sut.enqueue(1) {}

                    sut.enqueue(2) {}

                    sut.enqueue(3) {}

                    sut.dequeue { _ in }

                    sut.peek { result in
                        peekCompletionResult = result
                    }

                    expect(peekCompletionResult).toEventually(equal(2), timeout: .seconds(3))
                }

                it("should return nil if queue is empty") {
                    var peekCompletionResult: Int?

                    sut.enqueue(1) {}

                    sut.enqueue(2) {}

                    sut.dequeue { _ in }

                    sut.dequeue { _ in }

                    sut.peek { result in
                        peekCompletionResult = result
                    }

                    expect(peekCompletionResult).toEventually(beNil(), timeout: .seconds(3))
                }
            }

            context("isEmpty()") {
                it("should return false if queue is not empty") {
                    var isEmptyCompletionResult: Bool?

                    sut.enqueue(1) {}

                    sut.isEmpty { result in
                        isEmptyCompletionResult = result
                    }

                    expect(isEmptyCompletionResult).toEventually(equal(false), timeout: .seconds(3))
                }

                it("should return true if queue is empty") {
                    var isEmptyCompletionResult: Bool?

                    sut.enqueue(1) {}

                    sut.dequeue { _ in }

                    sut.isEmpty { result in
                        isEmptyCompletionResult = result
                    }

                    expect(isEmptyCompletionResult).toEventually(equal(true), timeout: .seconds(3))
                }
            }
        }
    }
}
