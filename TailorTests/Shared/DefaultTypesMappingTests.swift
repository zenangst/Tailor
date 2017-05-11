import Tailor
import Quick
import Nimble

class TestMappingDefaultTypes: QuickSpec {

  override func spec() {

    describe("mapping default types") {

      let dictionary: [String: Any] = [
        "name" : "Swedish Chef",
        "int": 1,
        "float": 2.5,
        "string": "1.25",
        "array" : [
          "foo", "bar", "baz"
        ]
      ]

      it("resolves the correct values") {

        expect(dictionary.value(forKey: "name", ofType: Double.self)).to(beNil())
        expect(dictionary.value(forKey: "name", ofType: Float.self)).to(beNil())
        expect(dictionary.value(forKey: "name", ofType: Int.self)).to(beNil())
        expect(dictionary.value(forKey: "name", ofType: String.self)).to(equal("Swedish Chef"))

        expect(dictionary.value(forKey: "float", ofType: Float.self)).to(equal(2.5))
        expect(dictionary.value(forKey: "float", ofType: Double.self)).to(equal(2.5))
        expect(dictionary.value(forKey: "float", ofType: Int.self)).to(equal(2))
        expect(dictionary.value(forKey: "float", ofType: String.self)).to(equal("2.5"))

        expect(dictionary.value(forKey: "int", ofType: Float.self)).to(equal(1.0))
        expect(dictionary.value(forKey: "int", ofType: Double.self)).to(equal(1.0))
        expect(dictionary.value(forKey: "int", ofType: Int.self)).to(equal(1))
        expect(dictionary.value(forKey: "int", ofType: String.self)).to(equal("1"))

        expect(dictionary.value(forKey: "string", ofType: Float.self)).to(equal(1.25))
        expect(dictionary.value(forKey: "string", ofType: Double.self)).to(equal(1.25))
        expect(dictionary.value(forKey: "string", ofType: Int.self)).to(equal(1))
        expect(dictionary.value(forKey: "string", ofType: String.self)).to(equal("1.25"))

        expect(dictionary.string("string")).to(equal("1.25"))

        expect(dictionary.float("name")).to(beNil())
        expect(dictionary.double("name")).to(beNil())
        expect(dictionary.int("name")).to(beNil())
        expect(dictionary.string("name")).to(equal("Swedish Chef"))

        expect(dictionary.float("float")).to(equal(2.5))
        expect(dictionary.double("float")).to(equal(2.5))
        expect(dictionary.int("float")).to(equal(2))
        expect(dictionary.string("float")).to(equal("2.5"))

        expect(dictionary.float("int")).to(equal(1))
        expect(dictionary.double("int")).to(equal(1))
        expect(dictionary.int("int")).to(equal(1))
        expect(dictionary.string("int")).to(equal("1"))

        expect(dictionary.float("string")).to(equal(1.25))
        expect(dictionary.double("string")).to(equal(1.25))
        expect(dictionary.int("string")).to(equal(1))
        expect(dictionary.string("string")).to(equal("1.25"))

      }
    }
  }
}
