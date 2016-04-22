import Sugar

public protocol PathAccessible {
  func path(path: [SubscriptKind]) -> JSONDictionary?
}

public extension PathAccessible {
  /**
   - Parameter name: The array of path, can be index or key
   - Returns: A child dictionary for that path, otherwise it returns nil
   */
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
}

extension Dictionary: PathAccessible {}
extension Array: PathAccessible {}