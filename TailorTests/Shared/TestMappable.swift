import XCTest
import Tailor
import Sugar

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
    let expectedJob = Job(["name" : "Musician"])

    let testStruct = TestPersonStruct([
      "firstName" : "Taylor",
      "lastName" : "Swift",
      "job" : ["name" : "Musician"],
      "sex": "female",
      "birth_date": "2014-07-15"
      ])

    XCTAssertEqual(testStruct.firstName, expectedStruct.firstName)
    XCTAssertEqual(testStruct.lastName, expectedStruct.lastName)
    XCTAssertEqual(testStruct.sex, expectedStruct.sex)
    XCTAssertEqual(testStruct.birthDate, expectedStruct.birthDate)
    XCTAssertEqual(testStruct.job?.name, expectedJob.name)
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

  func testRelations() {
    let relationStruct = TestPersonStruct([
        "firstName" : "Mini",
        "lastName" : "Swift",
        "sex": "female",
        "birth_date": "2014-07-15"
        ])
    var expectedStruct = TestPersonStruct([:])
    expectedStruct.firstName = "Taylor"
    expectedStruct.lastName = "Swift"
    expectedStruct.sex = .Female
    expectedStruct.birthDate = dateFormatter.dateFromString("2014-07-15")!
    expectedStruct.relatives.append(relationStruct)

    let testStruct = TestPersonStruct([
      "firstName" : "Taylor",
      "lastName" : "Swift",
      "sex": "female",
      "birth_date": "2014-07-15",
      "relatives" : [
        ["firstName" : "Mini",
        "lastName" : "Swift",
        "sex": "female",
        "birth_date": "2014-07-17"],
        ["firstName" : "Mini-Mini",
        "lastName" : "Swift",
        "sex": "female",
        "birth_date": "2014-07-18"]
      ]
      ])

    XCTAssertEqual(testStruct.firstName, expectedStruct.firstName)
    XCTAssertEqual(testStruct.lastName, expectedStruct.lastName)
    XCTAssertEqual(testStruct.sex, expectedStruct.sex)
    XCTAssertEqual(testStruct.birthDate, expectedStruct.birthDate)
    XCTAssertTrue(testStruct.relatives.count == 2)
    XCTAssertEqual(testStruct.relatives[0], relationStruct)
    XCTAssertEqual(testStruct.relatives[0].firstName, "Mini")
    XCTAssertEqual(testStruct.relatives[1].firstName, "Mini-Mini")
  }

  func testMapArrayOfObjects() {
    var testStruct = TestPersonStruct([:])
    let relatives: [[String : AnyObject]] = [
      ["firstName" : "Mini",
        "lastName" : "Swift",
        "sex": "female",
        "birth_date": "2014-07-17"],
      ["firstName" : "Mini-Mini",
        "lastName" : "Swift",
        "sex": "female",
        "birth_date": "2014-07-18"]]

    testStruct.relatives <- relatives.objects()
    XCTAssert(testStruct.relatives.count == 2)
  }

  func testAppendingObjects() {
    var testStruct = TestPersonStruct([:])
    let relatives: [[String : AnyObject]] = [
      ["firstName" : "Mini",
        "lastName" : "Swift",
        "sex": "female",
        "birth_date": "2014-07-17"],
      ["firstName" : "Mini-Mini",
        "lastName" : "Swift",
        "sex": "female",
        "birth_date": "2014-07-18"]]

    testStruct.relatives <+ relatives.objects()
    XCTAssert(testStruct.relatives.count == 2)
  }

  func testAppendingObject() {
    var testStruct = TestPersonStruct([:])
    let relatives: [String : AnyObject] = ["first" :
      ["firstName" : "Mini",
        "lastName" : "Swift",
        "sex": "female",
        "birth_date": "2014-07-17"]]

    testStruct.relatives <+ relatives.relation("first")
    XCTAssert(testStruct.relatives.count == 1)

    let copy = testStruct
    testStruct.relatives <+ copy
    XCTAssert(testStruct.relatives.count == 2)
  }

  func testValueLookupSuccess() {
    let personStruct = TestPersonStruct([
      "firstName" : "Mini",
      "lastName" : "Swift",
      "sex": "female",
      "birth_date": "2014-07-15"
      ])

    do {
      let firstName: String = try personStruct.value("firstName")
      let lastName: String? = try personStruct.value("lastName")
      XCTAssertEqual(firstName, "Mini")
      XCTAssertEqual(lastName, "Swift")
    } catch {}
  }

  func testValueLookupFailure() {
    let personStruct = TestPersonStruct([
      "firstName" : "Mini",
      "lastName" : "Swift",
      "sex": "female",
      "birth_date": "2014-07-15"
      ])

    do {
      let _: String? = try personStruct.value("firstName")
    } catch {
      XCTAssertNotNil(error)
    }
  }

  func testImmutableObjectMapping() {
    let immutableStruct: TestImmutable
    do {
      immutableStruct = try TestImmutable(["firstName" : "foo" ,
        "lastName" : "bar",
        "job" : ["name" : "Musician"],
        "hobbies" : [["name" : "Musician"]]
        ])
      let expectedJob = Job(["name" : "Musician"])

      XCTAssertEqual(immutableStruct.firstName, "foo")
      XCTAssertEqual(immutableStruct.lastName, "bar")
      XCTAssertEqual(immutableStruct.job.name, expectedJob.name)
      XCTAssertEqual(immutableStruct.hobbies.count, 1)
      XCTAssertEqual(immutableStruct.hobbies[0].name, expectedJob.name)
    } catch {
      print(error)
    }
  }

  func testMultipleTypes() {
    let multiTypeStruct = MultipleTypeStruct(
      [
        "stringArray" : ["a", "b", "c"],
        "stringDictionary" : ["a" : "a" , "b" : "b", "c" : "c"],
        "boolProperty" : true,
        "people" : [
          [
            "firstName" : "foo",
            "lastName" : "Swift",
            "sex": "female",
            "birth_date": "2014-07-15"
          ],
          [
            "firstName" : "bar",
            "lastName" : "Swift",
            "sex": "female",
            "birth_date": "2014-07-15"
          ]
        ],
        "peopleDictionary" : ["Mini" : [
          "firstName" : "Mini",
          "lastName" : "Swift",
          "sex": "female",
          "birth_date": "2014-07-15"
          ]]
      ]
    )

    XCTAssertEqual(multiTypeStruct.stringArray, ["a", "b", "c"])
    XCTAssertEqual(multiTypeStruct.stringDictionary, ["a" : "a" , "b" : "b", "c" : "c"])
    XCTAssertEqual(multiTypeStruct.boolProperty, true)
    XCTAssertEqual(multiTypeStruct.people.first?.firstName, TestPersonStruct(["firstName" : "foo"]).firstName)
    XCTAssertEqual(multiTypeStruct.peopleDictionary["Mini"]?.firstName, TestPersonStruct(["firstName" : "Mini"]).firstName)
    XCTAssertEqual(multiTypeStruct.people[1].firstName, "bar")
  }

  func testEnum() {
    enum State: String {
      case Open = "open"
      case Closed = "closed"
    }

    enum Priority: Int {
      case Low = 0
      case Medium = 1
      case High = 2
    }

    struct Issue: Mappable {
      var name: String = ""
      var state: State = .Closed
      var priority: Priority = .Low

      init(_ map: JSONDictionary) {
        self.name <- map.property("name")
        self.state <- map.`enum`("state")
        self.priority <- map.`enum`("priority")
      }
    }

    let json = [
      "name": "Swift 3 support",
      "state": "open",
      "priority": 2
    ]

    let issue = Issue(json)
    XCTAssertEqual(issue.name, "Swift 3 support")
    XCTAssertEqual(issue.state, State.Open)
    XCTAssertEqual(issue.priority, Priority.High)
  }

  func testPath() {
    let json = [
      "info": [
        "name": "Elliot Alderson",
        "true_info": [
          "true_name": "Mr. Robot"
        ]
      ],
      "chaos": [
        [
          "$": "@",
          "!": "&"
        ],
        [
          "way": [
            "light": [
              [
                "±": "§",
                "_": "="
              ],
              [
                "secret": "secret"
              ]
            ],
            "dark": ">\"<",
            "identity": [
              "day": "security",
              "night": "hacker"
            ]
          ]
        ]
      ]
    ]

    struct Person: Mappable {
      var name: String = ""
      var trueName: String = ""
      var secret: String = ""
      var identity: String = ""

      init(_ map: JSONDictionary) {
        self.name <- map.path(["info"])?.property("name")
        self.trueName <- map.path(["info", "true_info"])?.property("true_name")
        self.secret <- map.path(["chaos", 1, "way", "light", 1])?.property("secret")
        self.identity <- map.path("chaos.1.way.identity")?.property("night")
      }
    }

    let person = Person(json)
    XCTAssertEqual(person.name, "Elliot Alderson")
    XCTAssertEqual(person.trueName, "Mr. Robot")
    XCTAssertEqual(person.secret, "secret")
    XCTAssertEqual(person.identity, "hacker")
  }
}
