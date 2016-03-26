import Sugar

public extension Array {

  /**
   - Parameter name: String
   - Returns: A mappable object array, otherwise it returns nil
   */
  func objects<T : Mappable>(name: String? = nil) -> [T]? {
    var objects = [T]()

    if let name = name {
      for dictionary in self {
        guard let dictionary = dictionary as? JSONDictionary,
          value = dictionary[name] as? JSONDictionary else { continue }
        objects.append(T(value))
      }
    } else {
      for dictionary in self {
        guard let dictionary = dictionary as? JSONDictionary else { continue }
        objects.append(T(dictionary))
      }
    }

    return objects
  }
}
