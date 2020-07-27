import XCTest
@testable import Encryption

final class EncryptionTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Encryption().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
