import XCTest
extension XCTest {
    func XCTAssertThrowsErrorAsync(
        _ expression: @autoclosure () async throws -> Any,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
    
    func XCTAssertTrueAsync(_ expression: @autoclosure () async throws -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) async {
        do {
            let result = try await expression()
            XCTAssertTrue(result)
        } catch {
            XCTFail(message(), file: file, line: line)
        }
    }
}
