![Tailor Swift logo](https://raw.githubusercontent.com/zenangst/Tailor/master/Images/logo_v1.png)

[![CI Status](http://img.shields.io/travis/zenangst/Tailor.svg?style=flat)](https://travis-ci.org/zenangst/Tailor)
[![Version](https://img.shields.io/cocoapods/v/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)
[![Platform](https://img.shields.io/cocoapods/p/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)
![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)

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

  init(_ map: [String : Any]) {
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

## Mapping objects

```swift
struct Person: Mappable {

  var firstName: String? = ""
  var lastName: String? = ""
  var spouse: Person?
  var parents = [Person]()

  init(_ map: [String : Any]) {
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

  init(_ map: [String : Any]) throws {
    firstName = try map.property("firstName").unwrapOrThrow()
    lastName = try map.property("lastName").unwrapOrThrow()
    spouse = try map.relationOrThrow("spouse").unwrapOrThrow()
    parents = try map.relationsOrThrow("parents").unwrapOrThrow()
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

  init(_ map: [String : Any]) {
    firstName <- map.property("first_name")
    lastName  <- map.property("last_name")
    spouse    <- map.relation("spouse")
    parents   <- map.relations("parents")
    birthDate <- map.transform("birth_date", transformer: { (value: String) -> NSDate? in
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

## KeyPath

Tailor supports mapping values using deep keyPath

```swift
struct Book: Mappable {

  var title: String = ""
  var publisherName: String = ""
  var authorName: String = ""
  var firstReviewerName: String = ""

  init(_ map: [String : Any]) {
    title <- map.resolve(keyPath: "title")
    publisherName <- map.resolve(keyPath: "publisher.name")
    authorName <- map.resolve(keyPath: "info.author.name")
    firstReviewerName <- map.resolve(keyPath: "meta.reviewers.0.info.name.first_name")
  }
}
```

## Resolving value types.

Tailor supports mapping values from dictionaries using type specific functions.

```swift
dictionary.boolean("key")
dictionary.double("key")
dictionary.float("key")
dictionary.int("key")
dictionary.string("key")
```

You can also use `value(forKey:ofType:)`, it works like this.

```swift
dictionary.value(forKey: "key", ofType: Bool.self)
dictionary.value(forKey: "key", ofType: Double.self)
dictionary.value(forKey: "key", ofType: Float.self)
dictionary.value(forKey: "key", ofType: Int.self)
dictionary.value(forKey: "key", ofType: String.self)
```

All of these methods returns an optional value.

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
- Khoa Pham ([@onmyway133](https://twitter.com/onmyway133))
