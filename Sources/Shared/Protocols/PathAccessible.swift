import Sugar

public protocol PathAccessible {

  /**
   - Parameter name: The key path, separated by dot
   - Returns: A child dictionary for that path, otherwise it returns nil
   */
  func resolve(keyPath path: String) -> JSONDictionary?
}

public extension PathAccessible {

  private func internalResolve<T>(path: [SubscriptKind]) -> T? {
    var castedPath = path.dropFirst()
    castedPath.append(.Key(""))

    let pairs = zip(path, Array(castedPath))
    var result: Any = self

    for (kind, castedKind) in pairs {
      switch (kind, castedKind) {
      case (let .Key(name), .Key):
        result = (result as? JSONDictionary)?.dictionary(name)
      case (let .Key(name), .Index):
        result = (result as? JSONDictionary)?.array(name)
      case (let .Index(index), .Key):
        result = (result as? JSONArray)?.dictionary(index)
      case (let .Index(index), .Index):
        result = (result as? JSONArray)?.array(index)
      }
    }

    return result as? T
  }

  private func resolveSubscript<T>(key: String) -> T? {
    if let index = Int(key) {
      return [index] as? T
    } else {
      return (self as? JSONDictionary)?[key] as? T
    }
  }

  private func internalResolve<T>(path: String) -> T? {
    let kinds: [SubscriptKind] = path.componentsSeparatedByString(".").map {
      if let index = Int($0) {
        return .Index(index)
      } else {
        return .Key($0)
      }
    }

    return internalResolve(kinds)
  }

  /**
   Extract last key from key path

   - Parameter path: A key path
   - Returns: A tuple with the first key and the remaining key path
   */
  private func extractKey(path: String) -> (key: String, keyPath: String)? {
    guard let lastSplit = path.split(".").last where path.contains(".") else { return nil }

    return (key: lastSplit,
            keyPath: Array(path.split(".").dropLast()).joinWithSeparator("."))
  }

  @available(*, deprecated=1.1.3, message="Use resolve(keyPath:)")
  public func path(path: [SubscriptKind]) -> JSONDictionary? { return internalResolve(path) }
  @available(*, deprecated=1.1.3, message="Use resolve(keyPath:)")
  public func path<T>(path: String) -> T? { return resolve(keyPath: path) as? T }
  @available(*, deprecated=1.1.3, message="Use resolve(keyPath:)")
  public func path(path: String) -> String? { return resolve(keyPath: path) }
  @available(*, deprecated=1.1.3, message="Use resolve(keyPath:)")
  public func path(path: String) -> Int? { return resolve(keyPath: path) }
  @available(*, deprecated=1.1.3, message="Use resolve(keyPath:)")
  public func path(path: String) -> JSONArray? { return resolve(keyPath: path) }
  @available(*, deprecated=1.1.3, message="Use resolve(keyPath:)")
  public func path(path: String) -> JSONDictionary? { return resolve(keyPath: path) }

  /**
   Resolve key path to Dictionary

   - Parameter path: A key path string
   - Returns: An Optional [String : AnyObject]
   */
  func resolve(keyPath path: String) -> JSONDictionary? {
    return internalResolve(path)
  }

  /**
   Resolve key path to String

   - Parameter path: A key path string
   - Returns: An Optional String
   */
  func resolve(keyPath path: String) -> String? {
    guard let (key, keyPath) = extractKey(path) else {
      return resolveSubscript(path)
    }

    let result: JSONDictionary? = internalResolve(keyPath)
    return result?.property(key)
  }

  /**
   Resolve key path to Int

   - Parameter path: A key path string
   - Returns: An Optional Int
   */
  func resolve(keyPath path: String) -> Int? {
    guard let (key, keyPath) = extractKey(path) else {
      return resolveSubscript(path)
    }

    let result: JSONDictionary? = internalResolve(keyPath)
    return result?.property(key)
  }

  /**
   Resolve key path to Int

   - Parameter path: A key path string
   - Returns: An Optional Int
   */
  func resolve<T>(keyPath path: String) -> T? {
    guard let (key, keyPath) = extractKey(path) else {
      return resolveSubscript(path)
    }

    let result: JSONDictionary? = internalResolve(keyPath)
    return result?.property(key)
  }

  /**
   Resolve key path to [AnyObject]

  - Parameter path: A key path string
  - Returns: An Optional [AnyObject]
  */
  func resolve(keyPath path: String) -> JSONArray? {
    guard let (key, keyPath) = extractKey(path) else {
      return resolveSubscript(path)
    }

    let result: JSONDictionary? = internalResolve(keyPath)
    return result?.array(key)
  }
}

extension Dictionary: PathAccessible {}
extension Array: PathAccessible {}
