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
  
  required convenience init(_ map: [String : AnyObject]) {
    self.init()
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")

    sex <- map.propertyWithTransform("sex") { (value: String?) -> Sex? in
      var result: Sex?
      if let value = value {
        result = Sex(rawValue: value)
      }
      return result
    }
  }

  func mapping(map: [String : AnyObject]) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")
  }
}

struct TestPersonStruct: Inspectable, Equatable {
  var firstName: String = ""
  var lastName: String? = ""
  var sex: Sex = .Female

  init(_ map: [String : AnyObject]) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")

    sex <- map.propertyWithTransform("sex") { (value: String?) -> Sex? in
      var result: Sex?
      if let value = value {
        result = Sex(rawValue: value)
      }
      return result
    }
  }
}

func ==(lhs: TestPersonStruct, rhs: TestPersonStruct) -> Bool {
  return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}
