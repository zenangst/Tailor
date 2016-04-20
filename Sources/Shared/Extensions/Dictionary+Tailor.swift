import Sugar

// MARK: - Basic

public extension Dictionary {

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A generic type if casting succeeds, otherwise it throws
   */
  func propertyOrThrow<T>(name: String) throws -> T {
    guard let key = name as? Key,
      value = self[key] as? T
      else { throw MappableError.TypeError(message: "Tried to get value for \(name) as \(T.self)") }

    return value
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A generic type if casting succeeds, otherwise it returns nil
   */
  func property<T>(name: String) -> T? {
    guard let key = name as? Key,
      value = self[key] as? T
      else { return nil }

    return value
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Parameter transformer: A transformation closure
   - Returns: A generic type if casting succeeds, otherwise it returns nil
   */
  func transform<T, U>(name: String, transformer: ((value: U?) -> T?)) -> T? {
    guard let value = self[name as! Key] else { return nil }
    return transformer(value: value as? U)
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object directory, otherwise it returns nil
   */
  func directory<T : Mappable>(name: String) -> [String : T]? {
    guard let key = name as? Key, value = self[key],
      dictionary = value as? JSONDictionary
      else { return nil }

    var directory = [String : T]()

    for (key, value) in dictionary {
      guard let value = value as? JSONDictionary else { continue }
      directory[key] = T(value)
    }

    return directory
  }

  /**
   - Parameter name: The name of the key
   - Returns: A child dictionary for that key, otherwise it returns nil
   */
  func dictionary(name: String) -> JSONDictionary? {
    guard let key = name as? Key,
      value = self[key] as? JSONDictionary
      else { return nil }

    return value
  }

  /**
   - Parameter name: The name of the key
   - Returns: A child dictionary for that key, otherwise it throws
   */
  func dictionaryOrThrow(name: String) throws -> JSONDictionary {
    guard let key = name as? Key,
      value = self[key] as? JSONDictionary
      else { throw MappableError.TypeError(message: "Tried to get value for \(name) as JSONDictionary") }

    return value
  }

  /**
   - Parameter name: The name of the key
   - Returns: A child array for that key, otherwise it returns nil
   */
  func array(name: String) -> JSONArray? {
    guard let key = name as? Key,
      value = self[key] as? JSONArray
      else { return nil }

    return value
  }

  /**
   - Parameter name: The name of the key
   - Returns: A child array for that key, otherwise it throws
   */
  func arrayOrThrow(name: String) throws -> JSONArray {
    guard let key = name as? Key,
      value = self[key] as? JSONArray
      else { throw MappableError.TypeError(message: "Tried to get value for \(name) as JSONArray") }

    return value
  }
}

// MARK: - Relation

public extension Dictionary {

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object, otherwise it returns nil
   */
  func relation<T : Mappable>(name: String) -> T? {
    guard let value = self[name as! Key],
      dictionary = value as? JSONDictionary
      else { return nil }

    return T(dictionary)
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A generic type if casting succeeds, otherwise it throws
   */
  func relationOrThrow<T : Mappable>(name: String) throws -> T {
    guard let key = name as? Key,
      value = self[key],
      dictionary = value as? JSONDictionary
      else { throw MappableError.TypeError(message: "Tried to get value for \(name) as \(T.self)") }

    return T(dictionary)
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object, otherwise it returns nil
   */
  func relation<T : SafeMappable>(name: String) -> T? {
    guard let value = self[name as! Key],
      dictionary = value as? JSONDictionary
      else { return nil }

    let result: T?

    do {
      result = try T(dictionary)
    } catch {
      result = nil
    }

    return result
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A generic type if casting succeeds, otherwise it throws
   */
  func relationOrThrow<T : SafeMappable>(name: String) throws -> T {
    guard let key = name as? Key,
      value = self[key],
      dictionary = value as? JSONDictionary
      else { throw MappableError.TypeError(message: "Tried to get value for \(name) as \(T.self)") }

    return try T(dictionary)
  }
}

// MARK: - Relations

public extension Dictionary {

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object array, otherwise it returns nil
   */
  func relations<T : Mappable>(name: String) -> [T]? {
    guard let key = name as? Key, value = self[key],
      array = value as? JSONArray
      else { return nil }

    return array.map { T($0) }
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object array, otherwise it throws
   */
  func relationsOrThrow<T : Mappable>(name: String) throws -> [T] {
    guard let key = name as? Key,
      value = self[key],
      array = value as? JSONArray
      else { throw MappableError.TypeError(message: "Tried to get value for \(name) as \(T.self)") }

    return array.map { T($0) }
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object array, otherwise it returns nil
   */
  func relations<T : SafeMappable>(name: String) -> [T]? {
    guard let key = name as? Key, value = self[key],
      array = value as? JSONArray
      else { return nil }

    var result = [T]()

    do {
      result = try array.map { try T($0) }
    } catch {}

    return result
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object array, otherwise it throws
   */
  func relationsOrThrow<T : SafeMappable>(name: String) throws -> [T] {
    guard let key = name as? Key, value = self[key],
      array = value as? JSONArray
      else { throw MappableError.TypeError(message: "Tried to get value for \(name) as \(T.self)") }

    return try array.map { try T($0) }
  }
}
