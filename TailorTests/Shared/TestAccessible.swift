import Quick
import Nimble
import Tailor

struct Club {
  var people: [Person] = []

  init(_ map: [String : Any]) {
    people <- map.dictionary("detail")?.relations("people")
  }
}

struct Person: Mappable {

  var firstName: String? = ""
  var lastName: String? = ""

  init(_ map: [String : Any]) {
    firstName <- map.property("first_name")
    lastName  <- map.property("last_name")
  }
}

class TestAccessible: QuickSpec {
  override func spec() {
    describe("test accessible") {
      var json: [String : Any]!
      var expected: [[String : Any]]!
      var result: [[String : Any]]!
      var array: [String : Any]?
      var marvelClubJSON: [String : Any]!
      var club: Club!
      var tony: Person!
      var hulk: Person!

      beforeEach {
        json = [
          "school": [
            "name": "Hyper",
            "clubs": [
              [
                "detail": [
                  "name": "DC",
                  "people": [
                    [
                      "first_name": "Clark",
                      "last_name": "Kent",
                      "age" : 78
                    ],
                    [
                      "first_name": "Bruce",
                      "last_name": "Wayne",
                      "age" : 77
                    ]
                  ]
                ]
              ],
              [
                "detail": [
                  "name": "Marvel",
                  "people": [
                    [
                      "first_name": "Tony",
                      "last_name": "Stark",
                      "age" : 53
                    ],
                    [
                      "first_name": "Bruce",
                      "last_name": "Banner",
                      "age" : 54
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]

        expected =  [
          [
            "first_name": "Clark",
            "last_name": "Kent",
            "age" : 78
          ],
          [
            "first_name": "Bruce",
            "last_name": "Wayne",
            "age" : 77
          ]
        ]

        result = json.resolve(keyPath: "school.clubs.0.detail.people")!
        array = json.resolve(keyPath: "school")
        marvelClubJSON = json.dictionary("school")?.array("clubs")?.dictionary(1)
        club = Club(marvelClubJSON)
        tony = club.people[0]
        hulk = club.people[1]
      }

      it("has the correct detail name") {
        expect(json.resolve(keyPath: "school.clubs.0.detail.name")).to(equal("DC"))
      }

      it("has the correct first name") {
        expect(json.resolve(keyPath: "school.clubs.0.detail.people.0.first_name")).to(equal("Clark"))
      }

      it("has the correct age") {
        expect(json.resolve(keyPath: "school.clubs.0.detail.people.0.age")).to(equal(78))
      }

      it("Has the correct count") {
        expect(expected.count).to(equal(result.count))
      }

      it("has a non nil array") {
        expect(array).toNot(beNil())
      }

      it("has the right first name for iron man") {
        expect(tony.firstName).to(equal("Tony"))
      }

      it("has the right last name for iron man") {
        expect(tony.lastName).to(equal("Stark"))
      }

      it("has the right first name for hulk") {
        expect(hulk.firstName).to(equal("Bruce"))
      }

      it("has the right last name for hulk") {
        expect(hulk.lastName).to(equal("Banner"))
      }

      it("has the right school name for DC") {
        expect(json.resolve(keyPath: "school.clubs.0.detail.name")).to(equal("DC"))
      }

      it("has the right school name for Marvel") {
        expect(json.resolve(keyPath: "school.clubs.1.detail.name")).to(equal("Marvel"))
      }

      it("has the right first name through keypath for hulk") {
        expect(json.resolve(keyPath: "school.clubs.0.detail.people.1.first_name")).to(equal("Bruce"))
      }

    }

    describe("mapping floats") {
      var json: [String : Any]!

      beforeEach {
        json = [
          "values" : [
            "cgfloat" : CGFloat(10.0),
            "float" : Float(10.0),
            "double" : Double(10.0),
            "generic": 10.0
          ]
        ]
      }

      it("has the correct non-generic cgfloat value") {
        expect(json.resolve(keyPath: "values.cgfloat")).to(equal(CGFloat(10.0)))
      }

      it("has the correct non-generic float value") {
        expect(json.resolve(keyPath: "values.float")).to(equal(Float(10.0)))
      }

      it("has the correct non-generic double value") {
        expect(json.resolve(keyPath: "values.double")).to(equal(Double(10.0)))
      }

      it("has the correct generic value") {
        expect(json.resolve(keyPath: "values.generic")).to(equal(10.0))
      }

      it("has the correct generic CGFloat value") {
        expect(json.resolve(keyPath: "values.generic")).to(equal(CGFloat(10.0)))
      }

      it("has the correct generic double value") {
        expect(json.resolve(keyPath: "values.generic")).to(equal(Double(10.0)))
      }

    }

  }

}
