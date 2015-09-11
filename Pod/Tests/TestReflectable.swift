import XCTest
import Tailor

class TestReflectable: XCTestCase {

  func testReflectionOnClass() {
    let firstName = "John"
    let lastName = "Hyperseed"
    let person = TestPersonClass()
    person.firstName = firstName
    person.lastName = lastName

    XCTAssertEqual(firstName, person.firstName)
    XCTAssertEqual(firstName, person.property("firstName") as? String)
  }

  func testReflectionOnStruct() {
    let firstName = "John"
    let lastName = "Hyperseed"
    var person = TestPersonStruct([:])
    person.firstName = firstName
    person.lastName = lastName

    XCTAssertEqual(firstName, person.firstName)
    XCTAssertEqual(firstName, person.property("firstName") as? String)
  }

}
