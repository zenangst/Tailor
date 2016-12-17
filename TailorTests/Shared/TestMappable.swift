import Quick
import Nimble
import Tailor

class TestMappable: QuickSpec {

    lazy var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter
    }()

    override func spec() {

        describe("mapping") {

            context("struct") {
                var expectedStruct: TestPersonStruct!
                var expectedJob: Job!
                var testStruct: TestPersonStruct!

                beforeEach {
                    expectedStruct = TestPersonStruct([:])
                    expectedStruct.firstName = "Taylor"
                    expectedStruct.lastName = "Swift"
                    expectedStruct.sex = .Female
                    expectedStruct.birthDate = self.dateFormatter.date(from: "2014-07-15")!
                    expectedJob = Job(["name" : "Musician"])

                    testStruct = TestPersonStruct(
                        [
                            "firstName" : "Taylor",
                            "lastName" : "Swift",
                            "job" : ["name" : "Musician"],
                            "sex": "female",
                            "birth_date": "2014-07-15"
                        ]
                    )

                }

                it("has the correct first name") {
                    expect(testStruct.firstName).to(equal(expectedStruct.firstName))
                }

                it("has the correct last name") {
                    expect(testStruct.lastName).to(equal(expectedStruct.lastName))
                }

                it("has the correct sex") {
                    expect(testStruct.sex).to(equal(expectedStruct.sex))
                }

                it("has the correct birthdate") {
                    expect(testStruct.birthDate).to(equal(expectedStruct.birthDate))
                }

                it("has the correct job name") {
                    expect(testStruct.job?.name).to(equal(expectedJob.name))
                }
            }

            context("class") {
                var expectedClass: TestPersonClass!
                var testClass: TestPersonClass!

                beforeEach {
                    expectedClass = TestPersonClass([:])
                    expectedClass.firstName = "Taylor"
                    expectedClass.lastName = "Swift"
                    expectedClass.sex = .Female
                    expectedClass.birthDate = self.dateFormatter.date(from: "2014-07-15")

                    testClass = TestPersonClass(
                        [
                            "firstName" : "Taylor",
                            "lastName" : "Swift",
                            "sex": "female",
                            "birth_date": "2014-07-15"
                        ]
                    )
                }

                it("has the correct first name") {
                    expect(testClass.firstName).to(equal(expectedClass.firstName))
                }

                it("has the correct last name") {
                    expect(testClass.lastName).to(equal(expectedClass.lastName))
                }

                it("has the correct sex") {
                    expect(testClass.sex).to(equal(expectedClass.sex))
                }

                it("has the correct birthdate") {
                    expect(testClass.birthDate).to(equal(expectedClass.birthDate))
                }

            }

            context("relations") {
                var relationStruct: TestPersonStruct!
                var expectedStruct: TestPersonStruct!
                var testStruct: TestPersonStruct!

                beforeEach {
                    relationStruct = TestPersonStruct(
                        [
                            "firstName" : "Mini" as AnyObject,
                            "lastName" : "Swift" as AnyObject,
                            "sex": "female" as AnyObject,
                            "birth_date": "2014-07-15" as AnyObject
                        ]
                    )
                    expectedStruct = TestPersonStruct([:])
                    expectedStruct.firstName = "Taylor"
                    expectedStruct.lastName = "Swift"
                    expectedStruct.sex = .Female
                    expectedStruct.birthDate = self.dateFormatter.date(from: "2014-07-15")!
                    expectedStruct.relatives.append(relationStruct)

                    testStruct = TestPersonStruct(
                        [
                            "firstName" : "Taylor" as AnyObject,
                            "lastName" : "Swift" as AnyObject,
                            "sex": "female" as AnyObject,
                            "birth_date": "2014-07-15" as AnyObject,
                            "relatives" : [
                                [
                                    "firstName" : "Mini",
                                    "lastName" : "Swift",
                                    "sex": "female",
                                    "birth_date": "2014-07-17"
                                ],
                                [
                                    "firstName" : "Mini-Mini",
                                    "lastName" : "Swift",
                                    "sex": "female",
                                    "birth_date": "2014-07-18"
                                ]
                            ]
                        ]
                    )
                }

                it("has the correct fist name") {
                    expect(testStruct.firstName).to(equal(expectedStruct.firstName))
                }

                it("has the correct last name") {
                    expect(testStruct.lastName).to(equal(expectedStruct.lastName))
                }

                it("has the correct sex") {
                    expect(testStruct.sex).to(equal(expectedStruct.sex))
                }

                it("has the correct birth date") {
                    expect(testStruct.sex).to(equal(expectedStruct.sex))
                }

                it("has the correct number of relatives") {
                    expect(testStruct.relatives.count).to(equal(2))
                }

                it("first relative is the relation struct") {
                    expect(testStruct.relatives[0]).to(equal(relationStruct))
                }

                it("first relative has the correct name") {
                    expect(testStruct.relatives[0].firstName).to(equal("Mini"))
                }

                it("second relative has the correct name") {
                    expect(testStruct.relatives[1].firstName).to(equal("Mini-Mini"))
                }

            }

            context("array of objects") {
                var testStruct: TestPersonStruct!
                var relatives: [[String : Any]]!

                beforeEach {
                    testStruct = TestPersonStruct([:])
                    relatives = [
                        [
                            "firstName" : "Mini",
                            "lastName" : "Swift",
                            "sex": "female",
                            "birth_date": "2014-07-17"
                        ],
                        [
                            "firstName" : "Mini-Mini",
                            "lastName" : "Swift",
                            "sex": "female",
                            "birth_date": "2014-07-18"
                        ]
                    ]
                    testStruct.relatives <- relatives.objects()

                }

                it("has the correct number of relatives") {
                    expect(testStruct.relatives.count).to(equal(2))
                }

            }

            context("appending objects") {
                var testStruct: TestPersonStruct!
                var relatives: [[String : Any]]!

                beforeEach {
                    testStruct = TestPersonStruct([:])
                    relatives =  [
                        [
                            "firstName" : "Mini",
                            "lastName" : "Swift",
                            "sex": "female",
                            "birth_date": "2014-07-17"
                        ],
                        [
                            "firstName" : "Mini-Mini",
                            "lastName" : "Swift",
                            "sex": "female",
                            "birth_date": "2014-07-18"
                        ]
                    ]

                    testStruct.relatives <+ relatives.objects()
                }

                it("has the correct relative count") {
                    expect(testStruct.relatives.count).to(equal(2))
                }

            }

            context("appending object") {

                var testStruct: TestPersonStruct!
                var relatives: [String : Any]!
                var copy: TestPersonStruct!

                beforeEach {
                    testStruct = TestPersonStruct([:])
                    relatives = [
                        "first" : [
                            "firstName" : "Mini",
                            "lastName" : "Swift",
                            "sex": "female",
                            "birth_date": "2014-07-17"
                        ]
                    ]
                    testStruct.relatives <+ relatives.relation("first")
                    copy = testStruct
                }

                it("has one relative") {
                    expect(testStruct.relatives.count).to(equal(1))
                }

                context("after appending copy") {
                    beforeEach {
                        testStruct.relatives <+ copy
                    }

                    it("has two relatives") {
                        expect(testStruct.relatives.count).to(equal(2))
                    }
                }
            }

            describe("value lookup") {
                var personStruct: TestPersonStruct!

                beforeEach {
                    personStruct = TestPersonStruct(
                        [
                            "firstName" : "Mini",
                            "lastName" : "Swift",
                            "sex": "female",
                            "birth_date": "2014-07-15"
                        ]
                    )
                }

                context("value lookup success") {
                    var firstName: String!
                    var lastName: String!

                    it("is successful") {
                        do {
                            firstName = try personStruct.value("firstName")
                            lastName = try personStruct.value("lastName")
                            expect(firstName).to(equal("Mini"))
                            expect(lastName).to(equal("Swift"))
                        } catch {}
                    }
                }

                context("value lookup failure") {

                    it("has a non-nil error") {
                        expect { try personStruct.value("123") }.to(throwError()) 
                    }

                }

            }

            context("immutable object mapping") {

                var immutableStruct: TestImmutable!
                var expectedJob: Job!
                beforeEach {
                    immutableStruct = try! TestImmutable(
                        [
                            "firstName" : "foo",
                            "lastName" : "bar",
                            "job" : ["name" : "Musician"],
                            "hobbies" : [["name" : "Musician"]]
                        ]
                    )
                    expectedJob = Job(["name" : "Musician"])
                }

                it("has the correct first name") {
                    expect(immutableStruct.firstName).to(equal("foo"))
                }

                it("has the correct last name") {
                    expect(immutableStruct.lastName).to(equal("bar"))
                }

                it("has the correct job") {
                    expect(immutableStruct.job.name).to(equal(expectedJob.name))
                }

                it("has the correct number of hobbies") {
                    expect(immutableStruct.hobbies.count).to(equal(1))
                }

                it("has the correct hobby") {
                    expect(immutableStruct.hobbies[0].name).to(equal(expectedJob.name))
                }
            }

            context("Multiple types") {
                var multiTypeStruct: MultipleTypeStruct!

                beforeEach {
                    multiTypeStruct = MultipleTypeStruct(
                        [
                            "stringArray" : ["a", "b", "c"],
                            "stringDictionary" : ["a" : "a", "b" : "b", "c" : "c"],
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
                                ]
                            ]
                        ]
                    )
                }

                it("has the correct string array") {
                    expect(multiTypeStruct.stringArray).to(equal(["a", "b", "c"]))
                }

                it("has the correct string dict") {
                    expect(multiTypeStruct.stringDictionary).to(equal(["a" : "a", "b" : "b", "c" : "c"]))
                }

                it("has the correct bool property") {
                    expect(multiTypeStruct.boolProperty).to(beTruthy())
                }

                it("has the correct first name") {
                    expect(multiTypeStruct.people.first?.firstName).to(equal(TestPersonStruct(["firstName" : "foo"]).firstName))
                }

                it("has the correct people dict values") {
                    expect(multiTypeStruct.peopleDictionary["Mini"]?.firstName).to(equal(TestPersonStruct(["firstName" : "Mini"]).firstName))
                }

                it("has the correct last name on person 2") {
                    expect(multiTypeStruct.people[1].firstName).to(equal("bar"))
                }

            }

            context("enumerations") {

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

                    init(_ map: [String : Any]) {
                        self.name <- map.property("name")
                        self.state <- map.`enum`("state")
                        self.priority <- map.`enum`("priority")
                    }
                }

                var json: [String: Any]!
                var issue: Issue!

                beforeEach {
                    json = [
                        "name": "Swift 3 support",
                        "state": "open",
                        "priority": 2
                    ]
                    issue = Issue(json as [String : Any])
                }

                it("has the correct issue name") {
                    expect(issue.name).to(equal("Swift 3 support"))
                }

                it("Has the correct issue state") {
                    expect(issue.state).to(equal(State.Open))
                }

                it("has the correct issue priority") {
                    expect(issue.priority).to(equal(Priority.high))
                }

            }

            context("Path") {

                struct Person: Mappable {
                    var name: String = ""
                    var trueName: String = ""
                    var secret: String = ""
                    var identity: String = ""

                    init(_ map: [String : Any]) {
                        self.name <- map.resolve(keyPath: "info")?.property("name")
                        self.trueName <- map.resolve(keyPath: "info.true_info")?.property("true_name")
                        self.secret <- map.resolve(keyPath: "chaos.1.way.light.1")?.property("secret")
                        self.identity <- map.resolve(keyPath: "chaos.1.way.identity")?.property("night")
                    }
                }


                var json: [String: Any]!
                var person: Person!

                beforeEach {
                    json = [
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
                    person = Person(json as [String : Any])
                }

                it("has the correct name") {
                    expect(person.name).to(equal("Elliot Alderson"))
                }

                it("has the correct true name") {
                    expect(person.trueName).to(equal("Mr. Robot"))
                }

                it("has the correct secret") {
                    expect(person.secret).to(equal("secret"))
                }

                it("has the correct identity") {
                    expect(person.identity).to(equal("hacker"))
                }

            }

        }
    }

}
