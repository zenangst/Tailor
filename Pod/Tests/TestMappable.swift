import XCTest
import Tailor

class TestMappable: XCTestCase {

  func testMappableStruct() {
    var expectedStruct = TestPersonStruct([:])
    expectedStruct.firstName = "John"
    expectedStruct.lastName = "Hyperseed"

    let testStruct = TestPersonStruct([
      "firstName" : "John",
      "lastName" : "Hyperseed"
      ])

    XCTAssertEqual(testStruct, expectedStruct)
  }

  func testMappableClass() {
    let expectedClass = TestPersonClass([:])
    expectedClass.firstName = "John"
    expectedClass.lastName = "Hyperseed"

    let testClass = TestPersonClass([
      "firstName" : "John",
      "lastName" : "Hyperseed"
      ])

    XCTAssertEqual(testClass.firstName, expectedClass.firstName)
    XCTAssertEqual(testClass.lastName, expectedClass.lastName)
  }
}
