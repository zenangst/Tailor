import XCTest
import Tailor

class TestMappable: XCTestCase {

  func testMappableStruct() {
    var expectedStruct = TestPersonStruct([:])
    expectedStruct.firstName = "Taylor"
    expectedStruct.lastName = "Swift"

    let testStruct = TestPersonStruct([
      "firstName" : "Taylor",
      "lastName" : "Swift"
      ])

    XCTAssertEqual(testStruct, expectedStruct)
  }

  func testMappableClass() {
    let expectedClass = TestPersonClass([:])
    expectedClass.firstName = "Taylor"
    expectedClass.lastName = "Swift"

    let testClass = TestPersonClass([
      "firstName" : "Taylor",
      "lastName" : "Swift"
      ])

    XCTAssertEqual(testClass.firstName, expectedClass.firstName)
    XCTAssertEqual(testClass.lastName, expectedClass.lastName)
  }
}
