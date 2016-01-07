import Foundation
import Sugar
@testable import Tailor

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

class TestPersonClass: NSObject, Inspectable, Mappable {

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

struct TestPersonStruct: Inspectable, Mappable, Equatable {
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

    relatives <- map.objects("relatives")
    job <- map.object("job")
  }
}

func ==(lhs: TestPersonStruct, rhs: TestPersonStruct) -> Bool {
  return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}
