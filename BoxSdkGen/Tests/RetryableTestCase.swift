import XCTest
import Foundation

#if os(Linux)
class RetryableTestCase: XCTestCase {
    private static var maxRetries: Int = 3
    private static var finalFailureMessage: String = "Test failed after \(RetryableTestCase.maxRetries) attempts"
    private var failureMessages: [String] = []
    private var suppressFailures: Bool = false

    func runWithRetry(_ testMethod: () throws -> Void) {
        var lastFailureMessage: String? = nil
        for attempt in 1...RetryableTestCase.maxRetries {
            print("🔁 Attempt \(attempt) for \(self.name)")
            failureMessages.removeAll()
            suppressFailures = true

            do {
                try testMethod()
            } catch {
                failureMessages.append("Test threw error: \(error)")
            }

            if failureMessages.isEmpty {
                suppressFailures = false
                return
            }

            lastFailureMessage = failureMessages.last
            print("🔁 Retry attempt \(attempt) failed: \(lastFailureMessage ?? "Unknown failure")")
        }

        suppressFailures = false
        XCTFail("\(RetryableTestCase.finalFailureMessage): \(self.name), Last failure: \(lastFailureMessage ?? "No specific failure message")")
    }

    func runWithRetryAsync(_ testMethod: () async throws -> Void) async {
        var lastFailureMessage: String? = nil

        for attempt in 1...RetryableTestCase.maxRetries {
            print("🔁 Attempt \(attempt) for \(self.name)")
            failureMessages.removeAll()
            suppressFailures = true

            do {
                try await testMethod()
            } catch {
                failureMessages.append("Test threw error: \(error)")
            }

            if failureMessages.isEmpty {
                suppressFailures = false
                return
            }

            lastFailureMessage = failureMessages.last
            print("🔁 Retry attempt \(attempt) failed: \(lastFailureMessage ?? "Unknown failure")")
        }

        suppressFailures = false
        XCTFail("\(RetryableTestCase.finalFailureMessage): \(self.name), Last failure: \(lastFailureMessage ?? "No specific failure message")")
    }

    override func recordFailure(withDescription description: String, inFile fileName: String, atLine lineNumber: Int, expected: Bool) {
        failureMessages.append(description)

        if !suppressFailures {
            super.recordFailure(withDescription: description, inFile: fileName, atLine: lineNumber, expected: expected)
        }
    }
}

#else
class RetryableTestCase: XCTestCase {
    private static var maxRetries: Int = 3
    private static var finalFailureMessage: String = "Test failed after \(maxRetries) attempts"
    private var failureMessages: [String] = []

    override func invokeTest() {
        var lastFailureMessage: String? = nil
        for attempt in 1...RetryableTestCase.maxRetries {
            print("🔁 Attempt \(attempt) for \(self.name)")
            failureMessages.removeAll()
            super.invokeTest()
            if failureMessages.isEmpty {
                return
            }
            lastFailureMessage = failureMessages.first
            print("🔁 Retry attempt \(attempt) failed: \(lastFailureMessage ?? "Unknown failure")")
        }

        XCTFail("\(RetryableTestCase.finalFailureMessage): \(self.name), Last failure: \(lastFailureMessage ?? "No specific failure message")")
    }

    func runWithRetry(_ testMethod: () throws -> Void) {
        do {
            try testMethod()
        } catch {
            XCTFail("Test threw error: \(error)")
        }
    }

    func runWithRetryAsync(_ testMethod: () async throws -> Void) async {
        do {
            try await testMethod()
        } catch {
            XCTFail("Test threw error: \(error)")
        }
    }

    override func record(_ issue: XCTIssue) {
        failureMessages.append(issue.compactDescription)
        if(issue.compactDescription.contains(RetryableTestCase.finalFailureMessage)) {
            super.record(issue)
        }
    }
}
#endif
