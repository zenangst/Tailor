import Sugar

public protocol MappableOnce {
  init?(_ map: JSONDictionary) throws
}
