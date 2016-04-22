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
  func path(path: [SubscriptKind]) -> JSONDictionary? {
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

    return result as? JSONDictionary
  }

  func path(keyPath: String) -> JSONDictionary? {
    let kinds: [SubscriptKind] = keyPath.componentsSeparatedByString(".").map {
      if let index = Int($0) {
        return .Index(index)
      } else {
        return .Key($0)
      }
    }

    return path(kinds)
  }
}

extension Dictionary: PathAccessible {}
extension Array: PathAccessible {}
