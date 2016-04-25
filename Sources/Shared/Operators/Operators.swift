prefix operator <- {}
prefix operator <? {}
infix operator <- {}
infix operator <+ {}

public prefix func <-<T>(rhs: T?) throws -> T {
  guard let rhs = rhs else {
    throw MappableError.TypeError(message: "Unable to unrwap value")
  }
  return rhs
}

public prefix func <-<T>(rhs: T) throws -> T {
  return rhs
}

public prefix func <? <T: DefaultType>(value: T?) -> T {
  return value ?? T.defaultValue
}

public func <- <T>(inout left: T, right: T) {
  left = right
}

public func <- <T>(inout left: T, right: T?) {
  guard let right = right else { return }

  left = right
}

public func <+ <T>(inout left: [T], right: [T]?) {
  guard let right = right else { return }
  left.appendContentsOf(right)
}

public func <+ <T>(inout left: [T], right: T?) {
  guard let right = right else { return }
  left.append(right)
}
