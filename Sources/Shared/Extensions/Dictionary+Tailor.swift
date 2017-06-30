#if os(OSX)
  import Foundation
#else
  import UIKit
#endif
// MARK: - Basic

public extension Dictionary {

  /// Map value using key into Double
  ///
  /// - Parameter name: The name of the key.
  /// - Returns: An optional Double
  func double(_ name: String) -> Double? {
    if let value: Float = property(name) {
      return Double(value)
    }

    if let value: Int = property(name) {
      return Double(value)
    }

    if let value: String = property(name) {
      return Double(value)
    }

    return property(name)
  }

  /// Map value using key to Float
  ///
  /// - Parameter name: The name of the key.
  /// - Returns: An optional Float
  func float(_ name: String) -> Float? {
    if let value: Double = property(name) {
      return Float(value)
    }

    if let value: Int = property(name) {
      return Float(value)
    }

    if let value: String = property(name) {
      return Float(value)
    }

    return property(name)
  }

  /// Map value using key to Int
  ///
  /// - Parameter name: The name of the key.
  /// - Returns: An optional Int
  func int(_ name: String) -> Int? {
    if let value: Double = property(name) {
      return Int(value)
    }

    if let value: Float = property(name) {
      return Int(value)
    }

    if let value: String = property(name) {
      if let firstCharacter = value.characters.first, value.characters.count > 1 {
        return Int(String(firstCharacter))
      }

      return Int(value)
    }

    return property(name)
  }

  /// Map value using key to String
  ///
  /// - Parameter name: The name of the key.
  /// - Returns: An optional String
  func string(_ name: String) -> String? {
    if let value: Float = property(name) {
      return String(value)
    }

    if let value: Double = property(name) {
      return String(value)
    }

    if let value: Int = property(name) {
      return String(value)
    }

    return property(name)
  }

  /// Map value using key to String
  ///
  /// - Parameter name: The name of the key.
  /// - Returns: An optional String
  func boolean(_ name: String) -> Bool? {
    guard let key = name as? Key else {
      return nil
    }

    if let string = self[key] as? String {

      if ["true", "1"].contains(string.lowercased()) {
        return true
      } else if ["false", "0"].contains(string.lowercased()) {
        return false
      }

      return nil
    } else if let number = self[key] as? NSNumber {
      return number.boolValue
    } else if let boolean = self[key] as? Bool {
      return boolean
    } else {
      return nil
    }
  }

  /// A generic method that maps a value from a key to a specific type.
  ///
  /// - Parameters:
  ///   - forKey: The key that holds the value that should be mapped.
  ///   - ofType: The type that should be used for casting.
  /// - Returns: An optional value of the inferred type.
  func value<T>(forKey: String, ofType: T.Type) -> T? {
    guard let key = forKey as? Key else {
      return nil
    }

    guard let value = self[key] else {
      return nil
    }

    if let value = value as? T {
      return value
    } else {
      switch ofType {
      case is Bool.Type:
        return boolean(forKey) as? T
      case is Double.Type:
        return double(forKey) as? T
      case is Float.Type:
        return float(forKey) as? T
      case is String.Type:
        return string(forKey) as? T
      case is Int.Type:
        return int(forKey) as? T
      default:
        assertionFailure("Unsupported type: \(ofType)")
      }
    }

    return nil
  }

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
   - Returns: An enum if casting succeeds, otherwise it returns nil
   */
  func `enum`<T: RawRepresentable>(_ name: String) -> T? {
    guard let key = name as? Key,
      let value = self[key] as? T.RawValue
      else { return nil }

    return T(rawValue: value)
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
