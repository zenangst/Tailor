import Sugar

public extension Dictionary {

  func property<T>(name: String) -> T? {
    guard let key = name as? Key,
      value = self[key]
      else { return nil }

    return value as? T
  }

  func transform<T, U>(name: String, transformer: ((value: U?) -> T?)) -> T? {
    guard let value = self[name as! Key] else { return nil }
    return transformer(value: value as? U)
  }

  func relation<T : Mappable>(name: String) -> T? {
    guard let value = self[name as! Key],
      dictionary = value as? JSONDictionary
      else { return nil }

    return T(dictionary)
  }

  func relations<T : Mappable>(name: String) -> [T]? {
    guard let key = name as? Key, value = self[key],
      array = value as? JSONArray
      else { return nil }

    return array.map { T($0) }
  }
}
