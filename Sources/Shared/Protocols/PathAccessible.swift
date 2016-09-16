public protocol PathAccessible {

  /**
   - Parameter name: The key path, separated by dot
   - Returns: A child dictionary for that path, otherwise it returns nil
   */
  func resolve(keyPath path: String) -> [String : AnyObject]?
}

public extension PathAccessible {

  fileprivate func internalResolve<T>(_ path: [SubscriptKind]) -> T? {
    var castedPath = path.dropFirst()
    castedPath.append(.key(""))

    let pairs = zip(path, Array(castedPath))
    var result: Any = self

    for (kind, castedKind) in pairs {
      switch (kind, castedKind) {
      case (let .key(name), .key):
        result = (result as? [String : AnyObject])?.dictionary(name)
      case (let .key(name), .index):
        result = (result as? [String : AnyObject])?.array(name)
      case (let .index(index), .key):
        result = (result as? [[String : AnyObject]])?.dictionary(index)
      case (let .index(index), .index):
        result = (result as? [[String : AnyObject]])?.array(index)
      }
    }

    return result as? T
  }

  fileprivate func resolveSubscript<T>(_ key: String) -> T? {
    if let index = Int(key) {
      return [index] as? T
    } else {
      return (self as? [String : AnyObject])?[key] as? T
    }
  }

  fileprivate func internalResolve<T>(_ path: String) -> T? {
    let kinds: [SubscriptKind] = path.components(separatedBy: ".").map {
      if let index = Int($0) {
        return .index(index)
      } else {
        return .key($0)
      }
    }

    return internalResolve(kinds)
  }

  /**
   Extract last key from key path

   - Parameter path: A key path
   - Returns: A tuple with the first key and the remaining key path
   */
  fileprivate func extractKey(_ path: String) -> (key: String, keyPath: String)? {
    guard let lastSplit = path.components(separatedBy: ".").last, path.contains(".") else { return nil }

    return (key: lastSplit,
            keyPath: Array(path.components(separatedBy: ".").dropLast()).joined(separator: "."))
  }

  /**
   Resolve key path to Dictionary

   - Parameter path: A key path string
   - Returns: An Optional [String : AnyObject]
   */
  func resolve(keyPath path: String) -> [String : AnyObject]? {
    return internalResolve(path)
  }

  /**
   Resolve key path to Generic type

   - Parameter path: A key path string
   - Returns: An generic type
   */
  func resolve<T>(keyPath path: String) -> T? {
    guard let (key, keyPath) = extractKey(path) else {
      return resolveSubscript(path)
    }

    let result: [String : AnyObject]? = internalResolve(keyPath)
    return result?.property(key)
  }
}

extension Dictionary: PathAccessible {}
extension Array: PathAccessible {}
