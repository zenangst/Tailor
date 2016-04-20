import Sugar

public extension Array {

  /**
   - Parameter name: String
   - Returns: A mappable object array, otherwise it returns empty array
   */
  func objects<T : Mappable>(name: String? = nil) -> [T] {
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

  /**
   - Parameter name: String
   - Returns: A mappable object array, otherwise it returns nil
   */
  func objects<T : SafeMappable>(name: String? = nil) throws -> [T] {
    var objects = [T]()

    if let name = name {
      for dictionary in self {
        guard let dictionary = dictionary as? JSONDictionary,
          value = dictionary[name] as? JSONDictionary else { continue }
        objects.append(try T(value))
      }
    } else {
      for dictionary in self {
        guard let dictionary = dictionary as? JSONDictionary else { continue }
        objects.append(try T(dictionary))
      }
    }

    return objects
  }

  /**
   - Parameter name: The index
   - Returns: A child dictionary at that index, otherwise it returns nil
   */
  func dictionary(index: Int) -> JSONDictionary? {
    guard index < self.count, let value = self[index] as? JSONDictionary
      else { return nil }

    return value
  }

  /**
   - Parameter name: The index
   - Returns: A child array at that index, otherwise it returns nil
   */
  func array(index: Int) -> JSONArray? {
    guard index < self.count, let value = self[index] as? JSONArray
      else { return nil }

    return value
  }
}
