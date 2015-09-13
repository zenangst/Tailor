import Foundation
import Tailor

enum Sex: String {
  case Unspecified = "unspecified"
  case Male = "male"
  case Female = "female"
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

struct TestPersonStruct: Inspectable, Equatable {
  var firstName: String = ""
  var lastName: String? = ""
  var sex: Sex?
  var birthDate = NSDate(timeIntervalSince1970: 1)
  var relatives = [TestPersonStruct]()

  init(_ map: [String : AnyObject]) {
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

    relatives <- map.relation("relatives") { (objects: JSONArray?) -> [TestPersonStruct]? in
      guard let objects = objects else { return self.relatives }
      for object in objects { self.relatives.append(TestPersonStruct(object)) }
      return self.relatives
    }

  }
}

func ==(lhs: TestPersonStruct, rhs: TestPersonStruct) -> Bool {
  return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}
