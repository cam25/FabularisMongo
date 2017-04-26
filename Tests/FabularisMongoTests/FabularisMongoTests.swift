import XCTest
@testable import FabularisMongo

class FabularisMongoTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(FabularisMongo().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
