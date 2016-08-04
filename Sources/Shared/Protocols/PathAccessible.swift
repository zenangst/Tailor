import Sugar

public protocol PathAccessible {

  /**
   - Parameter name: The array of path, can be index or key
   - Returns: A child dictionary for that path, otherwise it returns nil
   */
  func path(path: [SubscriptKind]) -> JSONDictionary?

  /**
   - Parameter name: The key path, separated by dot
   - Returns: A child dictionary for that path, otherwise it returns nil
   */
  func path(keyPath: String) -> JSONDictionary?
}

public extension PathAccessible {

  private func resolve<T>(path: [SubscriptKind]) -> T? {
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

  private func resolve<T>(path: String) -> T? {
    let kinds: [SubscriptKind] = path.componentsSeparatedByString(".").map {
      if let index = Int($0) {
        return .Index(index)
      } else {
        return .Key($0)
      }
    }

    return resolve(kinds)
  }

  private func extractKey(path: String) -> (key: String, keyPath: String) {
    return (key: path.split(".").last!,
            keyPath: Array(path.split(".").dropLast()).joinWithSeparator("."))
  }

  func path(path: [SubscriptKind]) -> JSONDictionary? {
    return resolve(path)
  }

  func path(keyPath: String) -> JSONDictionary? {
    return resolve(keyPath)
  }

  func path(keyPath: String) -> String? {
    let (key, keyPath) = extractKey(keyPath)
    let result: JSONDictionary? = resolve(keyPath)
    return result?.property(key)
  }

  func path(keyPath: String) -> Int? {
    let (key, keyPath) = extractKey(keyPath)
    let result: JSONDictionary? = resolve(keyPath)
    return result?.property(key)
  }

  func path(keyPath: String) -> JSONArray? {
    let (key, keyPath) = extractKey(keyPath)
    let result: JSONDictionary? = resolve(keyPath)
    return result?.array(key)
  }
}

extension Dictionary: PathAccessible {}
extension Array: PathAccessible {}
