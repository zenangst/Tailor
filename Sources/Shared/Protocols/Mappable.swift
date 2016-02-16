import Sugar

public protocol Mappable {
  init(_ map: JSONDictionary)
}

public extension Mappable {

  public func value<T>(key: String) throws -> T {
    let value = Mirror(reflecting: self)
      .children
      .filter { $0.label == key }
      .map { $1 }.first

    guard let objectValue = value as? T else {
      throw MappableError.TypeError(message: "Tried to get value \(value!) for \(key) as \(T.self) when expecting \(types()[key]!)")
    }

    return objectValue
  }

  public func property<T>(key: String, dictionary: T? = nil) -> T? {
    // TODO: Improve this to support nested attributes
    let components = ArraySlice(key.componentsSeparatedByString("."))
    let value = Mirror(reflecting: self)
      .children
      .filter({$0.0! == components.first!})
      .map({ $1 }).first!

    var result = value as? T

    let tail = components.dropFirst()
    if let indexString = tail.first,
      index = Int(indexString) {
        result = (value as! [T])[index]

        if tail.count > 1 {
          guard let range = key.rangeOfString(indexString) else { return nil }
          let key = key.substringFromIndex(range.startIndex.advancedBy(2))
          return property(key, dictionary: result)
        } else {
          return result
        }
    }

    let type:_MirrorType = _reflect(value)
    if type.disposition == .Optional && type.count != 0 {
      let (_, some) = type[0]
      result = some.value as? T
    }

    return result
  }

  public func properties() -> [String : Any] {
    var properties = [String : Any]()
    for (key, object) in Mirror(reflecting: self).children {
      guard let key = key else { continue }
      properties[key] = object
    }

    return properties
  }

  public func types() -> [String : String] {
    var types = [String : String]()
    for tuple in Mirror(reflecting: self).children {
      let (key, value) = tuple
      let valueMirror = Mirror(reflecting: value)
      types[key!] = "\(valueMirror.subjectType)"
    }
    return types
  }

  public func keys() -> [String] { return Mirror(reflecting: self).children.map { $0.0! } }
  public func values() -> [Any]  { return Mirror(reflecting: self).children.map { $1 } }
}
