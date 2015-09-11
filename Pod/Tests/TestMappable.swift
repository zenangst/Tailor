import XCTest
import Tailor

class TestMappable: XCTestCase {

  lazy var dateFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    return dateFormatter
    }()

  func testMappableStruct() {
    var expectedStruct = TestPersonStruct([:])
    expectedStruct.firstName = "Taylor"
    expectedStruct.lastName = "Swift"
    expectedStruct.sex = .Female
    expectedStruct.birthDate = dateFormatter.dateFromString("2014-07-15")!

    let testStruct = TestPersonStruct([
      "firstName" : "Taylor",
      "lastName" : "Swift",
      "sex": "female",
      "birth_date": "2014-07-15"
      ])

    XCTAssertEqual(testStruct.firstName, expectedStruct.firstName)
    XCTAssertEqual(testStruct.lastName, expectedStruct.lastName)
    XCTAssertEqual(testStruct.sex, expectedStruct.sex)
    XCTAssertEqual(testStruct.birthDate, expectedStruct.birthDate)
  }

  func testMappableClass() {
    let expectedClass = TestPersonClass([:])
    expectedClass.firstName = "Taylor"
    expectedClass.lastName = "Swift"
    expectedClass.sex = .Female
    expectedClass.birthDate = dateFormatter.dateFromString("2014-07-15")

    let testClass = TestPersonClass([
      "firstName" : "Taylor",
      "lastName" : "Swift",
      "sex": "female",
      "birth_date": "2014-07-15"
      ])

    XCTAssertEqual(testClass.firstName, expectedClass.firstName)
    XCTAssertEqual(testClass.lastName, expectedClass.lastName)
    XCTAssertEqual(testClass.sex, expectedClass.sex)
    XCTAssertEqual(testClass.birthDate, expectedClass.birthDate)
  }
}
