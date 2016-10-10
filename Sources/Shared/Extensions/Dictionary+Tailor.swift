#if os(OSX)
  import Foundation
#else
  import UIKit
#endif
// MARK: - Basic

public extension Dictionary {

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A generic type if casting succeeds, otherwise it returns nil
   */
  func property<T>(_ name: String) -> T? {
    guard let key = name as? Key, let value = self[key] else { return nil }

    if let double = value as? Double, T.self == CGFloat.self {
      return CGFloat(double) as? T
    }

    return value as? T
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A generic type if casting succeeds, otherwise it throws
   */
  func propertyOrThrow<T>(_ name: String) throws -> T {
    guard let result: T = property(name)
      else { throw MappableError.typeError(message: "Tried to get value for \(name) as \(T.self)") }

    return result
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Parameter transformer: A transformation closure
   - Returns: A generic type if casting succeeds, otherwise it returns nil
   */
  func transform<T, U>(_ name: String, transformer: ((_ value: U) -> T?)) -> T? {
    guard let key = name as? Key,
      let value = self[key] as? U
      else { return nil }

    return transformer(value)
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object directory, otherwise it returns nil
   */
  func directory<T: Mappable>(_ name: String) -> [String : T]? {
    guard let key = name as? Key,
      let dictionary = self[key] as? [String : Any]
      else { return nil }

    var directory = [String: T]()

    for (key, value) in dictionary {
      guard let value = value as? [String : Any] else { continue }
      directory[key] = T(value)
    }

    return directory
  }

  /**
   - Parameter name: The name of the key
   - Returns: A child dictionary for that key, otherwise it returns nil
   */
  func dictionary(_ name: String) -> [String : Any]? {
    guard let key = name as? Key,
      let value = self[key] as? [String : Any]
      else { return nil }

    return value
  }

  /**
   - Parameter name: The name of the key
   - Returns: A child dictionary for that key, otherwise it throws
   */
  func dictionaryOrThrow(_ name: String) throws -> [String : Any] {
    guard let result = dictionary(name)
      else { throw MappableError.typeError(message: "Tried to get value for \(name) as [String : Any]") }

    return result
  }

  /**
   - Parameter name: The name of the key
   - Returns: A child array for that key, otherwise it returns nil
   */
  func array(_ name: String) -> [[String : Any]]? {
    guard let key = name as? Key,
      let value = self[key] as? [[String : Any]]
      else { return nil }

    return value
  }

  /**
   - Parameter name: The name of the key
   - Returns: A child array for that key, otherwise it throws
   */
  func arrayOrThrow(_ name: String) throws -> [[String : Any]] {
    guard let result = array(name)
      else { throw MappableError.typeError(message: "Tried to get value for \(name) as [[String : Any]]") }

    return result
  }

  /**
   - Parameter name: The name of the key
   - Returns: An enum if casting succeeds, otherwise it returns nil
   */
  func `enum`<T: RawRepresentable>(_ name: String) -> T? {
    guard let key = name as? Key,
      let value = self[key] as? T.RawValue
      else { return nil }

    return T(rawValue: value)
  }

  /**
   - Parameter name: The name of the key
   - Returns: An enum if casting succeeds, otherwise it throws
   */
  func enumOrThrow<T: RawRepresentable>(_ name: String) throws -> T {
    guard let result: T = `enum`(name)
      else { throw MappableError.typeError(message: "Tried to get value for \(name) as enum") }

    return result
  }
}

// MARK: - Relation

public extension Dictionary {

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object, otherwise it returns nil
   */
  func relation<T: Mappable>(_ name: String) -> T? {
    guard let key = name as? Key,
      let dictionary = self[key] as? [String : Any]
      else { return nil }

    return T(dictionary)
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A generic type if casting succeeds, otherwise it throws
   */
  func relationOrThrow<T: Mappable>(_ name: String) throws -> T {
    guard let result: T = relation(name)
      else { throw MappableError.typeError(message: "Tried to get value for \(name) as \(T.self)") }

    return result
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object, otherwise it returns nil
   */
  func relation<T: SafeMappable>(_ name: String) -> T? {
    guard let key = name as? Key,
      let dictionary = self[key] as? [String : Any]
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
  func relationOrThrow<T: SafeMappable>(_ name: String) throws -> T {
    guard let result: T = relation(name)
      else { throw MappableError.typeError(message: "Tried to get value for \(name) as \(T.self)") }

    return result
  }
}

// MARK: - Relations

public extension Dictionary {

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object array, otherwise it returns nil
   */
  func relations<T: Mappable>(_ name: String) -> [T]? {
    guard let key = name as? Key,
      let array = self[key] as? [[String : Any]]
      else { return nil }

    return array.map { T($0) }
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object array, otherwise it throws
   */
  func relationsOrThrow<T: Mappable>(_ name: String) throws -> [T] {
    guard let result: [T] = relations(name)
      else { throw MappableError.typeError(message: "Tried to get value for \(name) as \(T.self)") }

    return result
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object array, otherwise it returns nil
   */
  func relations<T: SafeMappable>(_ name: String) -> [T]? {
    guard let key = name as? Key,
      let array = self[key] as? [[String : Any]]
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
  func relationsOrThrow<T: SafeMappable>(_ name: String) throws -> [T] {
    guard let result: [T] = relations(name)
      else { throw MappableError.typeError(message: "Tried to get value for \(name) as \(T.self)") }

    return result
  }
}

// MARK: - Relation Hierarchically

public extension Dictionary {

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object, considering hierarchy, otherwise it returns nil
   */
  func relationHierarchically<T>(_ name: String) -> T? where T: Mappable, T: HierarchyType {
    guard let key = name as? Key,
      let dictionary = self[key] as? [String : Any]
      else { return nil }

    return T.cluster(dictionary) as? T
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object array, considering hierarchy, otherwise it returns nil
   */
  func relationsHierarchically<T>(_ name: String) -> [T]? where T: Mappable, T: HierarchyType {
    guard let key = name as? Key,
      let array = self[key] as? [[String : Any]]
      else { return nil }

    return array.flatMap { T.cluster($0) as? T }
  }
}
