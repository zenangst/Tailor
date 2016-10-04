public extension Array {

  /**
   - Parameter name: String
   - Returns: A mappable object array, otherwise it returns empty array
   */
  func objects<T: Mappable>(_ name: String? = nil) -> [T] {
    var objects = [T]()

    if let name = name {
      for dictionary in self {
        guard let dictionary = dictionary as? [String : Any],
          let value = dictionary[name] as? [String : Any] else { continue }
        objects.append(T(value))
      }
    } else {
      for dictionary in self {
        guard let dictionary = dictionary as? [String : Any] else { continue }
        objects.append(T(dictionary))
      }
    }

    return objects
  }

  /**
   - Parameter name: String
   - Returns: A mappable object array, otherwise it returns nil
   */
  func objects<T: SafeMappable>(_ name: String? = nil) throws -> [T] {
    var objects = [T]()

    if let name = name {
      for dictionary in self {
        guard let dictionary = dictionary as? [String : Any],
          let value = dictionary[name] as? [String : Any] else { continue }
        objects.append(try T(value))
      }
    } else {
      for dictionary in self {
        guard let dictionary = dictionary as? [String : Any] else { continue }
        objects.append(try T(dictionary))
      }
    }

    return objects
  }

  /**
   - Parameter name: The index
   - Returns: A child dictionary at that index, otherwise it returns nil
   */
  func dictionary(_ index: Int) -> [String : Any]? {
    guard index < self.count, let value = self[index] as? [String : Any]
      else { return nil }

    return value
  }

  /**
   - Parameter name: The index
   - Returns: A child array at that index, otherwise it returns nil
   */
  func array(_ index: Int) -> [[String : Any]]? {
    guard index < self.count, let value = self[index] as? [[String : Any]]
      else { return nil }

    return value
  }
}
