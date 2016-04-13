import Foundation
import Tailor
import Sugar

enum Sex: String {
  case Unspecified = "unspecified"
  case Male = "male"
  case Female = "female"
}

struct Job: Mappable {
  var name: String = ""

  init(_ map: JSONDictionary) {
    name <- map.property("name")
  }
}

let dateTransformer = { (value: String?) -> NSDate? in
  guard let value = value else { return nil }
  let dateFormatter = NSDateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd"
  return dateFormatter.dateFromString(value)
}

func ==(lhs: Job, rhs: Job) -> Bool {
  return lhs.name == rhs.name
}

class TestPersonClass: NSObject, Mappable {

  var firstName: String = ""
  var lastName: String? = ""
  var sex: Sex = .Unspecified
  var birthDate: NSDate?

  required convenience init(_ map: JSONDictionary) {
    self.init()
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")

    sex <- map.transform("sex") { (value: String?) -> Sex? in
      guard let value = value else { return nil }
      return Sex(rawValue: value)
    }

    birthDate <- map.transform("birth_date") { (value: String?) -> NSDate? in
      guard let value = value else { return nil }
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.dateFromString(value)
    }
  }

  func mapping(map: JSONDictionary) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")
  }
}

struct TestPersonStruct: Mappable, Equatable {
  var firstName: String = ""
  var lastName: String? = ""
  var sex: Sex?
  var birthDate = NSDate(timeIntervalSince1970: 1)
  var job: Job? = nil
  var relatives = [TestPersonStruct]()
  let children = [TestPersonStruct]()

  init(_ map: JSONDictionary) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")

    sex <- map.transform("sex") { (value: String?) -> Sex? in
      guard let value = value else { return nil }
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

  init(_ map: JSONDictionary) throws {
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

  init(_ map: JSONDictionary) {
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
