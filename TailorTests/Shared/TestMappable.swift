import XCTest
import Tailor

class TestMappable: XCTestCase {

  lazy var dateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    return dateFormatter
    }()

  func testMappableStruct() {
    var expectedStruct = TestPersonStruct([:])
    expectedStruct.firstName = "Taylor"
    expectedStruct.lastName = "Swift"
    expectedStruct.sex = .Female
    expectedStruct.birthDate = dateFormatter.date(from: "2014-07-15")!
    let expectedJob = Job(["name" : "Musician" as AnyObject])

    let testStruct = TestPersonStruct([
      "firstName" : "Taylor" as AnyObject,
      "lastName" : "Swift" as AnyObject,
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
    expectedClass.birthDate = dateFormatter.date(from: "2014-07-15")

    let testClass = TestPersonClass([
      "firstName" : "Taylor" as AnyObject,
      "lastName" : "Swift" as AnyObject,
      "sex": "female" as AnyObject,
      "birth_date": "2014-07-15" as AnyObject
      ])

    XCTAssertEqual(testClass.firstName, expectedClass.firstName)
    XCTAssertEqual(testClass.lastName, expectedClass.lastName)
    XCTAssertEqual(testClass.sex, expectedClass.sex)
    XCTAssertEqual(testClass.birthDate, expectedClass.birthDate)
  }

  func testRelations() {
    let relationStruct = TestPersonStruct([
        "firstName" : "Mini" as AnyObject,
        "lastName" : "Swift" as AnyObject,
        "sex": "female" as AnyObject,
        "birth_date": "2014-07-15" as AnyObject
        ])
    var expectedStruct = TestPersonStruct([:])
    expectedStruct.firstName = "Taylor"
    expectedStruct.lastName = "Swift"
    expectedStruct.sex = .Female
    expectedStruct.birthDate = dateFormatter.date(from: "2014-07-15")!
    expectedStruct.relatives.append(relationStruct)

    let testStruct = TestPersonStruct([
      "firstName" : "Taylor" as AnyObject,
      "lastName" : "Swift" as AnyObject,
      "sex": "female" as AnyObject,
      "birth_date": "2014-07-15" as AnyObject,
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
      ["firstName" : "Mini" as AnyObject,
        "lastName" : "Swift" as AnyObject,
        "sex": "female" as AnyObject,
        "birth_date": "2014-07-17" as AnyObject],
      ["firstName" : "Mini-Mini" as AnyObject,
        "lastName" : "Swift" as AnyObject,
        "sex": "female" as AnyObject,
        "birth_date": "2014-07-18"]]

    testStruct.relatives <- relatives.objects()
    XCTAssert(testStruct.relatives.count == 2)
  }

  func testAppendingObjects() {
    var testStruct = TestPersonStruct([:])
    let relatives: [[String : AnyObject]] = [
      ["firstName" : "Mini" as AnyObject,
        "lastName" : "Swift" as AnyObject,
        "sex": "female" as AnyObject,
        "birth_date": "2014-07-17" as AnyObject],
      ["firstName" : "Mini-Mini" as AnyObject,
        "lastName" : "Swift" as AnyObject,
        "sex": "female" as AnyObject,
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
      "firstName" : "Mini" as AnyObject,
      "lastName" : "Swift" as AnyObject,
      "sex": "female" as AnyObject,
      "birth_date": "2014-07-15" as AnyObject
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
      "firstName" : "Mini" as AnyObject,
      "lastName" : "Swift" as AnyObject,
      "sex": "female" as AnyObject,
      "birth_date": "2014-07-15" as AnyObject
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
      immutableStruct = try TestImmutable(["firstName" : "foo" as AnyObject ,
        "lastName" : "bar" as AnyObject,
        "job" : ["name" : "Musician"],
        "hobbies" : [["name" : "Musician"]]
        ])
      let expectedJob = Job(["name" : "Musician" as AnyObject])

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
      case low = 0
      case medium = 1
      case high = 2
    }

    struct Issue: Mappable {
      var name: String = ""
      var state: State = .Closed
      var priority: Priority = .low

      init(_ map: [String : AnyObject]) {
        self.name <- map.property("name")
        self.state <- map.`enum`("state")
        self.priority <- map.`enum`("priority")
      }
    }

    let json = [
      "name": "Swift 3 support",
      "state": "open",
      "priority": 2
    ] as [String : Any]

    let issue = Issue(json as [String : AnyObject])
    XCTAssertEqual(issue.name, "Swift 3 support")
    XCTAssertEqual(issue.state, State.Open)
    XCTAssertEqual(issue.priority, Priority.high)
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
    ] as [String : Any]

    struct Person: Mappable {
      var name: String = ""
      var trueName: String = ""
      var secret: String = ""
      var identity: String = ""

      init(_ map: [String : AnyObject]) {
        self.name <- map.resolve(keyPath: "info")?.property("name")
        self.trueName <- map.resolve(keyPath: "info.true_info")?.property("true_name")
        self.secret <- map.resolve(keyPath: "chaos.1.way.light.1")?.property("secret")
        self.identity <- map.resolve(keyPath: "chaos.1.way.identity")?.property("night")
      }
    }

    let person = Person(json as [String : AnyObject])
    XCTAssertEqual(person.name, "Elliot Alderson")
    XCTAssertEqual(person.trueName, "Mr. Robot")
    XCTAssertEqual(person.secret, "secret")
    XCTAssertEqual(person.identity, "hacker")
  }
}
