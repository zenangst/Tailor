![Tailor Swift logo](https://raw.githubusercontent.com/zenangst/Tailor/master/Images/logo_v1.png)

[![CI Status](http://img.shields.io/travis/zenangst/Tailor.svg?style=flat)](https://travis-ci.org/zenangst/Tailor)
[![Version](https://img.shields.io/cocoapods/v/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)
[![License](https://img.shields.io/cocoapods/l/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)
[![Platform](https://img.shields.io/cocoapods/p/Tailor.svg?style=flat)](http://cocoadocs.org/docsets/Tailor)

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

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create pull request


## Who made this?

- Christoffer Winterkvist ([@zenangst](https://twitter.com/zenangst))
- Vadym Markov ([@vadymmarkov](https://twitter.com/vadymmarkov))
