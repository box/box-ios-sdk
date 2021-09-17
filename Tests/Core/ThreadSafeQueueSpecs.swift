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
    var sut: ThreadSafeQueue<Int>!

    override func spec() {
        describe("ThreadSafeQueueSpecs") {

            beforeEach {
                self.sut = ThreadSafeQueue(completionQueue: DispatchQueue(label: "com.box.swiftsdk.threadsafequeue.test", qos: .utility))
            }

            context("enqueue()") {
                it("should add item in order of execution") {
                    var orderedCompletionResult: [Int] = []

                    self.sut.enqueue(1) {
                        orderedCompletionResult.append(1)
                    }

                    self.sut.enqueue(2) {
                        orderedCompletionResult.append(2)
                    }

                    expect(orderedCompletionResult).toEventually(equal([1, 2]), timeout: DispatchTimeInterval.seconds(5))
                }
            }

            context("dequeue()") {
                it("should pass nil to completion clousure if queue is empty") {
                    var orderedCompletionResult: [Int?] = []

                    self.sut.dequeue { result in
                        orderedCompletionResult.append(result)
                    }

                    expect(orderedCompletionResult).toEventually(equal([nil]), timeout: DispatchTimeInterval.seconds(2))
                }

                it("should be executed in the same order as enqueue elements") {
                    var orderedCompletionResult: [Int?] = []

                    self.sut.enqueue(1) {
                        orderedCompletionResult.append(1)
                    }

                    self.sut.enqueue(2) {
                        orderedCompletionResult.append(2)
                    }

                    self.sut.dequeue { result in
                        orderedCompletionResult.append(result)
                    }

                    self.sut.dequeue { result in
                        orderedCompletionResult.append(result)
                    }

                    expect(orderedCompletionResult).toEventually(equal([1, 2, 1, 2]), timeout: DispatchTimeInterval.seconds(3))
                }
            }

            context("peek()") {
                it("should return first item added to queue if queue is not empty") {
                    var peekCompletionResult: Int?

                    self.sut.enqueue(1) {}

                    self.sut.enqueue(2) {}

                    self.sut.enqueue(3) {}

                    self.sut.dequeue { _ in }

                    self.sut.peek { result in
                        peekCompletionResult = result
                    }

                    expect(peekCompletionResult).toEventually(equal(2), timeout: DispatchTimeInterval.seconds(3))
                }

                it("should return nil if queue is empty") {
                    var peekCompletionResult: Int?

                    self.sut.enqueue(1) {}

                    self.sut.enqueue(2) {}

                    self.sut.dequeue { _ in }

                    self.sut.dequeue { _ in }

                    self.sut.peek { result in
                        peekCompletionResult = result
                    }

                    expect(peekCompletionResult).toEventually(beNil(), timeout: DispatchTimeInterval.seconds(3))
                }
            }

            context("isEmpty()") {
                it("should return false if queue is not empty") {
                    var isEmptyCompletionResult: Bool?

                    self.sut.enqueue(1) {}

                    self.sut.isEmpty { result in
                        isEmptyCompletionResult = result
                    }

                    expect(isEmptyCompletionResult).toEventually(equal(false), timeout: DispatchTimeInterval.seconds(3))
                }

                it("should return true if queue is empty") {
                    var isEmptyCompletionResult: Bool?

                    self.sut.enqueue(1) {}

                    self.sut.dequeue { _ in }

                    self.sut.isEmpty { result in
                        isEmptyCompletionResult = result
                    }

                    expect(isEmptyCompletionResult).toEventually(equal(true), timeout: DispatchTimeInterval.seconds(3))
                }
            }
        }
    }
}
