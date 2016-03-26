import Sugar

public protocol Mappable {
  init(_ map: JSONDictionary)
}

public extension Mappable {

  /**
   - Parameter key: The key name of the property you want to lookup
   - Returns: A generic value on success, otherwise it throws a MappableError.
   */
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

  /**
   - Parameter key: The key name of the property you want to lookup
   - Returns: An optional generic value.
   */
  public func property<T>(key: String, dictionary: T? = nil) -> T? {
    // TODO: Improve this to support nested attributes
    let components = key.split(".")
    let values = Mirror(reflecting: self)
      .children
      .filter({$0.0 == components.first})
      .map({ $1 })

    guard let value = values.first else { return nil }
    var result = value as? T

    let tail = components.dropFirst()
    let type:_MirrorType = _reflect(value)

    if type.disposition == .Optional && type.count != 0 {
      let (_, some) = type[0]
      result = some.value as? T
    }

    if let indexString = tail.first,
      index = Int(indexString) {
        guard let result = (value as? [T])?[index] else { return nil }

        if tail.count > 1 {
          guard let range = key.rangeOfString(indexString) else { return nil }
          let key = key.substringFromIndex(range.startIndex.advancedBy(2))
          return property(key, dictionary: result)
        } else {
          return result
        }
    }

    return result
  }

  /**
   - Returns: A key-value dictionary.
   */
  public func properties() -> [String : Any] {
    var properties = [String : Any]()

    for tuple in Mirror(reflecting: self).children {
      guard let key = tuple.label else { continue }
      properties[key] = tuple.value
    }

    return properties
  }

  /**
  - Returns: A string based dictionary.
  */
  public func types() -> [String : String] {
    var types = [String : String]()
    for tuple in Mirror(reflecting: self).children {
      guard let key = tuple.label else { continue }
      types[key] = "\(Mirror(reflecting: tuple.value).subjectType)"
    }
    return types
  }

  public func keys() -> [String] { return Mirror(reflecting: self).children.map { $0.0! } }
  public func values() -> [Any]  { return Mirror(reflecting: self).children.map { $1 } }
}
