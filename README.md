![Tailor Swift logo](https://raw.githubusercontent.com/zenangst/Tailor/master/Images/logo_v1.png)

A super fast & convenient object mapper tailored for your needs.

Mapping objects to arrays or dictionaries can be a really cumbersome task, but those
days are over. Tailor features a whole bunch of nifty methods for your model sewing needs.

## Mapping properties

Tailor features property, relation(s) mapping for both `struct` and `class` objects.

## Struct
```swift
struct Person: Mappable {

  var firstName: String? = ""
  var lastName: String? = ""

  init(_ map: JSONDictionary) {
    firstName <- map.property("first_name")
    lastName  <- map.property("last_name")
  }
}

let dictionary = ["first_name" : "Taylor", "last_name" : "Swift"]
let model = Person(dictionary)
```

## Class
```swift
class Person: Mappable {

  var firstName: String? = ""
  var lastName: String? = ""

  required convenience init(_ map: [String : AnyObject]) {
    self.init()
    firstName <- map.property("first_name")
    lastName  <- map.property("last_name")
  }
}

let dictionary = ["first_name" : "Taylor", "last_name" : "Swift"]
let model = Person(dictionary)
```

## Object mapping

```swift
struct Person: Mappable {

  var firstName: String? = ""
  var lastName: String? = ""
  var spouse: Person?

  init(_ map: JSONDictionary) {
    firstName <- map.property("first_name")
    lastName  <- map.property("last_name")
    spouse    <- map.relation("spouse")
  }
}

let dictionary = [
  "first_name" : "Taylor",
  "last_name" : "Swift",
  "spouse" : ["first_name" : "Calvin",
              "last_name" : "Harris"]
]
let model = Person(dictionary)
```

## Mapping objects

```swift
struct Person: Mappable {

  var firstName: String? = ""
  var lastName: String? = ""
  var spouse: Person?
  var parents = [Person]()

  init(_ map: JSONDictionary) {
    firstName <- map.property("first_name")
    lastName  <- map.property("last_name")
    spouse    <- map.relation("spouse")
    parents   <- map.relations("parents")
  }
}

let dictionary = [
  "first_name" : "Taylor",
  "last_name" : "Swift",
  "spouse" : ["first_name" : "Calvin",
              "last_name" : "Harris"],
  "parents" : [
             ["first_name" : "Andrea",
              "last_name" : "Swift"],
              ["first_name" : "Scott",
              "last_name" : "Swift"]
  ]
]
let model = Person(dictionary)
```

## SafeMappable
```swift
struct ImmutablePerson: SafeMappable {
  let firstName: String
  let lastName: String
  let spouse: Person
  let parents = [Person]()

  init(_ map: JSONDictionary) throws {
    firstName = try <-map.property("firstName")
    lastName = try <-map.property("lastName")
    spouse = try <-map.relationOrThrow("spouse")
    parents = try <-map.relationsOrThrow("parents")
  }
}

let immutablePerson: ImmutablePerson
do {
  immutablePerson = try TestImmutable(["firstName" : "foo" , "lastName" : "bar"])
} catch {
  print(error)
}
```

## Transforms

```swift
struct Person: Mappable {

  var firstName: String? = ""
  var lastName: String? = ""
  var spouse: Person?
  var parents = [Person]()
  var birthDate = NSDate?

  init(_ map: JSONDictionary) {
    firstName <- map.property("first_name")
    lastName  <- map.property("last_name")
    spouse    <- map.relation("spouse")
    parents   <- map.relations("parents")
    birthDate <- map.transform("birth_date", transformer: { (value: String?) -> NSDate? in
      guard let value = value else { return nil }
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.dateFromString(value)
    })
  }
}

let dictionary = [
  "first_name" : "Taylor",
  "last_name" : "Swift",
  "spouse" : ["first_name" : "Calvin",
              "last_name" : "Harris"],
  "parents" : [
             ["first_name" : "Andrea",
              "last_name" : "Swift"],
              ["first_name" : "Scott",
              "last_name" : "Swift"]
  ],
  "birth_date": "1989-12-13"
]
let model = Person(dictionary)
```

## Installation

**Tailor** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Tailor'
```

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create pull request


## Who made this?

- Christoffer Winterkvist ([@zenangst](https://twitter.com/zenangst))
- Vadym Markov ([@vadymmarkov](https://twitter.com/vadymmarkov))
