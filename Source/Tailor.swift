infix operator <- {}

public func <- <T>(inout left: T, right: T) {
  left = right
}

public func <- <T>(inout left: T, right: T?) {
  guard let right = right else { return }
  left = right
}

public protocol Reflectable { }
public protocol Mappable: class {
  init(_ map: [String : AnyObject])
  func mapping(map: [String : AnyObject])
}

public extension Reflectable {

  public func property(key: String, dictionary: Any? = nil) -> Any? {
    // TODO: Improve this to support nested attributes
    let components = ArraySlice(key.componentsSeparatedByString("."))
    let value = Mirror(reflecting: self)
      .children
      .filter({$0.0! == components.first!})
      .map({ $1 }).first!
    return value
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
    guard let value = self[name as! Key] else { return nil }
    return value as? T
  }
}
