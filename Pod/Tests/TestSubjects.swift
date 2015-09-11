import Foundation
import Tailor

class TestPersonClass: NSObject, Reflectable, Mappable {
  var firstName: String = ""
  var lastName: String? = ""
  
  required convenience init(_ map: [String : AnyObject]) {
    self.init()
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")
  }

  func mapping(map: [String : AnyObject]) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")
  }
}

struct TestPersonStruct: Reflectable, Equatable {
  var firstName: String = ""
  var lastName: String? = ""
  
  init(_ map: [String : AnyObject]) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")
  }
}

func ==(lhs: TestPersonStruct, rhs: TestPersonStruct) -> Bool {
  return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}
