import Sugar

public extension Array {
  func objects<T : Mappable>(name: String? = nil) -> [T]? {
    var objects = [T]()

    if let name = name {
      for dictionary in self {
        guard let dictionary = dictionary as? JSONDictionary,
          value = dictionary[name] as? JSONDictionary else { continue }
        let object = T(value)
        objects.append(object)
      }
    } else {
      for dictionary in self {
        guard let dictionary = dictionary as? JSONDictionary else { continue }
        let object = T(dictionary)
        objects.append(object)
      }
    }

    return objects
  }
}
