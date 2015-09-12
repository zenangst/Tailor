infix operator <- {}
public typealias JSONArray = [[String : AnyObject]]
public typealias JSONDictionary = [String : AnyObject]

public func <- <T>(inout left: T, right: T) {
  left = right
}

public func <- <T>(inout left: T, right: T?) {
  guard let right = right else { return }
  left = right
}

public protocol Inspectable { }
public protocol Mappable: class {
  init(_ map: [String : AnyObject])
}

public extension Inspectable {

  public func property<T>(key: String, dictionary: T? = nil) -> T? {
    // TODO: Improve this to support nested attributes
    let components = ArraySlice(key.componentsSeparatedByString("."))
    let value = Mirror(reflecting: self)
      .children
      .filter({$0.0! == components.first!})
      .map({ $1 }).first!

    var result = value as? T
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

public extension Dictionary {

  func property<T>(name: String) -> T? {
    guard let key = name as? Key, value = self[key] else { return nil }
    return value as? T
  }

  func transform<T, U>(name: String, transform: ((value: U?) -> T?)? = nil) -> T? {
    guard let value = self[name as! Key] else { return nil }
    guard let transform = transform else { return value as? T }
    return transform(value: value as? U)
  }

  func relation<T, U>(name: String, transform: ((value: U?) -> T?)? = nil) -> T? {
    guard let key = name as? Key, value = self[key] else { return nil }
    guard let transform = transform else { return value as? T }
    return transform(value: self[key] as? U)
  }
}
