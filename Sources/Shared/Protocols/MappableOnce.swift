import Sugar

public protocol SafeMappable {
  init(_ map: JSONDictionary) throws
}
