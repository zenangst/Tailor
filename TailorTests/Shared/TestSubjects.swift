import Foundation
import Tailor

enum Sex: String {
  case Unspecified = "unspecified"
  case Male = "male"
  case Female = "female"
}

struct Job: Mappable {
  var name: String = ""

  init(_ map: [String : AnyObject]) {
    name <- map.property("name")
  }
}

let dateTransformer = { (value: String) -> Date? in
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd"
  return dateFormatter.date(from: value)
}

func ==(lhs: Job, rhs: Job) -> Bool {
  return lhs.name == rhs.name
}

class TestPersonClass: NSObject, Mappable {

  var firstName: String = ""
  var lastName: String? = ""
  var sex: Sex = .Unspecified
  var birthDate: Date?

  required convenience init(_ map: [String : AnyObject]) {
    self.init()
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")

    sex <- map.transform("sex") { (value: String) -> Sex? in
      return Sex(rawValue: value)
    }

    birthDate <- map.transform("birth_date") { (value: String) -> Date? in
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.date(from: value)
    }
  }
}

struct TestPersonStruct: Mappable, Equatable {
  var firstName: String = ""
  var lastName: String? = ""
  var sex: Sex?
  var birthDate = Date(timeIntervalSince1970: 1)
  var job: Job? = nil
  var relatives = [TestPersonStruct]()
  let children = [TestPersonStruct]()

  init(_ map: [String : AnyObject]) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")

    sex <- map.transform("sex") { (value: String) -> Sex? in
      return Sex(rawValue: value)
    }

    birthDate <- map.transform("birth_date", transformer: dateTransformer)

    relatives <- map.relations("relatives")
    job <- map.relation("job")
  }
}

struct TestImmutable: SafeMappable {
  let firstName: String
  let lastName: String
  let job: Job
  let hobbies: [Job]

  init(_ map: [String : AnyObject]) throws {
    firstName = try <-map.property("firstName")
    lastName = try <-map.property("lastName")
    job = try <-map.relationOrThrow("job")
    hobbies = try <-map.relationsOrThrow("hobbies")
  }
}

struct MultipleTypeStruct : Mappable {
  var stringArray = [String]()
  var stringDictionary = [String : String]()
  var boolProperty = false
  var people = [TestPersonStruct]()
  var peopleDictionary = [String : TestPersonStruct]()

  init(_ map: [String : AnyObject]) {
    stringArray <- map.property("stringArray")
    stringDictionary <- map.property("stringDictionary")
    boolProperty <- map.property("boolProperty")
    people <- map.relations("people")
    peopleDictionary <- map.directory("peopleDictionary")
  }
}

func ==(lhs: TestPersonStruct, rhs: TestPersonStruct) -> Bool {
  return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}
