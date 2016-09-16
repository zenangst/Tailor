import XCTest
import Tailor

struct Club {
  var people: [Person] = []

  init(_ map: [String : AnyObject]) {
    people <- map.dictionary("detail")?.relations("people")
  }
}

struct Person: Mappable {

  var firstName: String? = ""
  var lastName: String? = ""

  init(_ map: [String : AnyObject]) {
    firstName <- map.property("first_name")
    lastName  <- map.property("last_name")
  }
}

class TestAccessible: XCTestCase {
  func testAccessible() {
    let json: [String : AnyObject] = [
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
      ] as AnyObject
    ]

    XCTAssertEqual(json.resolve(keyPath: "school.clubs.0.detail.name"), "DC")
    XCTAssertEqual(json.resolve(keyPath: "school.clubs.0.detail.people.0.first_name"), "Clark")
    XCTAssertEqual(json.resolve(keyPath: "school.clubs.0.detail.people.0.age"), 78)

    let array: [String : AnyObject]? = json.resolve(keyPath: "school")
    XCTAssertNotNil(array)

    if let marvelClubJSON = json.dictionary("school")?.array("clubs")?.dictionary(1) {
      let club = Club(marvelClubJSON)

      let tony = club.people[0]

      XCTAssertEqual(tony.firstName, "Tony")
      XCTAssertEqual(tony.lastName, "Stark")

      let hulk = club.people[1]

      XCTAssertEqual(hulk.firstName, "Bruce")
      XCTAssertEqual(hulk.lastName, "Banner")
    }

    XCTAssertEqual(json.resolve(keyPath: "school.clubs.0.detail.name"), "DC")
    XCTAssertEqual(json.resolve(keyPath: "school.clubs.1.detail.name"), "Marvel")

    XCTAssertEqual(json.resolve(keyPath: "school.clubs.0.detail.people.1.first_name"), "Bruce")
  }
}
