// Tailor Mac Playground

import Cocoa
import Tailor

struct Person: Mappable, Equatable {
  var firstName: String = ""
  var lastName: String? = ""
  var age: Int = 0

  init(_ map: [String : AnyObject]) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")
    age       <- map.property("age")
  }
}

func ==(lhs: Person, rhs: Person) -> Bool {
  return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
}

let taylor = Person(["firstName" : "Taylor", "lastName" : "Swift", "age" : 27])

do {
  let firstName: String = try taylor.value("firstName")
  let lastName: String? = try taylor.value("lastName")
  let age: Int = try taylor.value("age")
} catch { print(error) }

