# Tailor Swift

[![CI Status](http://img.shields.io/travis/zenangst/Tailor.svg?style=flat)](https://travis-ci.org/zenangst/Tailor)
[![Version](https://img.shields.io/cocoapods/v/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)
[![License](https://img.shields.io/cocoapods/l/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)
[![Platform](https://img.shields.io/cocoapods/p/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)

## Work in progress

## Usage

### Structs
```swift
struct PersonStruct {
  var firstName: String = ""
  var lastName: String? = ""

  init(_ map: [String : AnyObject]) {
    firstName <- map.property("firstName")
    lastName  <- map.property("lastName")
  }
}

let testStruct = PersonStruct([
  "firstName" : "Taylor",
  "lastName"  : "Swift"
])
```

### Classes
```swift
class PersonClass: NSObject, Mappable {
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

let testClass = PersonClass([
  "firstName" : "Taylor",
  "lastName"  : "Swift"
])
```

## Installation

**Tailor** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Tailor'
```

## Author

Christoffer Winterkvist, christoffer@winterkvist.com

## License

**Tailor** is available under the MIT license. See the LICENSE file for more info.
