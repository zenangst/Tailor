public protocol Mappable {
  init(_ map: [String : Any])
}

public extension Mappable {

  /**
   - Parameter key: The key name of the property you want to lookup
   - Returns: A generic value on success, otherwise it throws a MappableError.
   */
  public func value<T>(_ key: String) throws -> T {
    let value = Mirror(reflecting: self)
      .children
      .filter { $0.label == key }
      .map { $1 }.first

    guard let objectValue = value as? T else {
      throw MappableError.typeError(message: "Tried to get value \(String(describing: value)) for \(key) as \(T.self) when expecting \(String(describing: types()[key]))")
    }

    return objectValue
  }

  /**
   - Parameter key: The key name of the property you want to lookup
   - Returns: An optional generic value.
   */
  public func property<T>(_ key: String, dictionary: T? = nil) -> T? {
    let components = key.components(separatedBy: ".")
    let values = Mirror(reflecting: self)
      .children
      .filter({$0.0 == components.first})
      .map({ $1 })

    guard let value = values.first else { return nil }
    var result = value as? T

    let tail = components.dropFirst()
    let type = Mirror.init(reflecting: value)

    if type.displayStyle == .optional && !type.children.isEmpty,
      let (_, value) = type.children.first {
      result = value as? T
    }

    if let indexString = tail.first,
      let index = Int(indexString) {
      guard let result = (value as? [T])?[index] else { return nil }

      if tail.count > 1 {
        guard let range = key.range(of: indexString) else { return nil }
        let key = key.substring(from: range.lowerBound)
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
    var properties = [String: Any]()

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
    var types = [String: String]()
    for tuple in Mirror(reflecting: self).children {
      guard let key = tuple.label else { continue }
      types[key] = "\(Mirror(reflecting: tuple.value).subjectType)"
    }
    return types
  }

  public func keys() -> [String] { return Mirror(reflecting: self).children.map { $0.0! } }
  public func values() -> [Any] { return Mirror(reflecting: self).children.map { $1 } }
}
