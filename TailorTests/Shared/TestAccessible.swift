import XCTest
import Tailor
import Sugar

struct Club {
  var people: [Person] = []

  init(_ map: JSONDictionary) {
    people <- map.dictionary("detail")?.relations("people")
  }
}

struct Person: Mappable {

  var firstName: String? = ""
  var lastName: String? = ""

  init(_ map: JSONDictionary) {
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
                  "last_name": "Kent"
                ],
                [
                  "first_name": "Bruce",
                  "last_name": "Wayne"
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
                  "last_name": "Stark"
                ],
                [
                  "first_name": "Bruce",
                  "last_name": "Banner"
                ]
              ]
            ]
          ]
        ]
      ]
    ]

    XCTAssertEqual(json.path("school.clubs.0.detail.name"), "DC")
    XCTAssertEqual(json.path("school.clubs.0.detail.people.0.first_name"), "Clark")
    XCTAssertEqual(json.path("school.clubs.0.detail.people")!, [
      [
        "first_name": "Clark",
        "last_name": "Kent"
      ],
      [
        "first_name": "Bruce",
        "last_name": "Wayne"
      ]
      ])

    if let marvelClubJSON = json.dictionary("school")?.array("clubs")?.dictionary(1) {
      let club = Club(marvelClubJSON)

      let tony = club.people[0]

      XCTAssertEqual(tony.firstName, "Tony")
      XCTAssertEqual(tony.lastName, "Stark")

      let hulk = club.people[1]

      XCTAssertEqual(hulk.firstName, "Bruce")
      XCTAssertEqual(hulk.lastName, "Banner")
    }
  }
}
