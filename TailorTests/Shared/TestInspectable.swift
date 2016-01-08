import XCTest
import Tailor

class TestInspectable: XCTestCase {

  func testInspectableOnClass() {
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

  func testInspectableOnStruct() {
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

  func testNestedAttributes() {
    let data: [String : AnyObject] = ["firstName" : "Taylor",
      "lastName" : "Swift",
      "sex": "female",
      "birth_date": "2014-07-15"]

    var parent = TestPersonStruct(data)
    var clone = parent
    clone.firstName += " + Clone"

    parent.relatives.append(clone)

    XCTAssertEqual(parent.property("relatives.0"), clone)
  }
}
