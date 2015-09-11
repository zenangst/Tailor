import XCTest
import Tailor

class TestReflectable: XCTestCase {

  func testReflectionOnClass() {
    let firstName = "Taylor"
    let lastName = "Swift"
    let sex = Sex.Female

    let person = TestPersonClass()
    person.firstName = firstName
    person.lastName = lastName
    person.sex = sex

    XCTAssertEqual(firstName, person.firstName)
    XCTAssertEqual(firstName, person.property("firstName"))
    XCTAssertEqual(lastName, person.lastName)
    XCTAssertEqual(lastName, person.property("lastName"))
    XCTAssertEqual(sex, person.sex)
    XCTAssertEqual(sex, person.property("sex"))
  }

  func testReflectionOnStruct() {
    let firstName = "Taylor"
    let lastName = "Swift"
    let sex = Sex.Female

    var person = TestPersonStruct([:])
    person.firstName = firstName
    person.lastName = lastName
    person.sex = sex

    XCTAssertEqual(firstName, person.firstName)
    XCTAssertEqual(firstName, person.property("firstName"))
    XCTAssertEqual(lastName, person.lastName)
    XCTAssertEqual(lastName, person.property("lastName"))
    XCTAssertEqual(sex, person.sex)
    XCTAssertEqual(sex, person.property("sex"))
  }
}
