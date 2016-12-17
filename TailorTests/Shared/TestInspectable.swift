import XCTest
import Tailor
import Quick
import Nimble

class TestInspectable: QuickSpec {

    override func spec() {

        describe("inspectable") {

            var firstName: String!
            var lastName: String!
            var sex: Sex!

            beforeEach {
                firstName = "Taylor"
                lastName = "Swift"
                sex = Sex.Female
            }

            context("on class") {

                var person: TestPersonClass!

                beforeEach {
                    person = TestPersonClass()
                    person.firstName = firstName
                    person.lastName = lastName
                    person.sex = sex
                }

                it("has the correct first name") {
                    expect(firstName).to(equal(person.firstName))
                }

                it("has the correct first name property") {
                    expect(firstName).to(equal(person.property("firstName")))
                }

                it("has the correct last name") {
                    expect(lastName).to(equal(person.lastName))
                }

                it("has the correct last name property") {
                    expect(lastName).to(equal(person.property("lastName")))
                }

                it("has the correct sex") {
                    expect(sex).to(equal(person.sex))
                }

                it("has the correct sex property") {
                    expect(sex).to(equal(person.property("sex")))
                }

            }

            context("on struct") {

                var person: TestPersonStruct!

                beforeEach {
                    person = TestPersonStruct([:])
                    person.firstName = firstName
                    person.lastName = lastName
                    person.sex = sex
                }


                it("has the correct first name") {
                    expect(firstName).to(equal(person.firstName))
                }

                it("has the correct first name property") {
                    expect(firstName).to(equal(person.property("firstName")))
                }

                it("has the correct last name") {
                    expect(lastName).to(equal(person.lastName))
                }

                it("has the correct last name property") {
                    expect(lastName).to(equal(person.property("lastName")))
                }

                it("has the correct sex") {
                    expect(sex).to(equal(person.sex))
                }

                it("has the correct sex property") {
                    expect(sex).to(equal(person.property("sex")))
                }

            }

        }

        describe("nested attributes") {
            var data: [String : Any]!
            var parent: TestPersonStruct!
            var clone: TestPersonStruct!

            beforeEach {
                data = [
                    "firstName" : "Taylor",
                    "lastName" : "Swift",
                    "sex": "female",
                    "birth_date": "2014-07-15"
                ]
                parent = TestPersonStruct(data)
                clone = parent
                clone.firstName += " + Clone"
                parent.relatives.append(clone)
            }

            it("references the correct relative") {
                expect(parent.property("relatives.0")).to(equal(clone))
            }

        }


    }
}
