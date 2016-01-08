// Tailor Mac Playground

import Cocoa
import Tailor

struct Person: Inspectable, Mappable, Equatable {
  var firstName: String = ""
  var lastName: String? = ""

  init(_ map: [String : AnyObject]) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")
  }
}

func ==(lhs: Person, rhs: Person) -> Bool {
  return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}

let taylor = Person(["firstName" : "Taylor", "lastName" : "Swift"])
print(taylor.firstName)
print(taylor.lastName)