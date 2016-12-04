prefix operator <-
prefix operator <?
infix operator <-
infix operator <+

public prefix func <- <T>(rhs: T?) throws -> T {
  guard let rhs = rhs else {
    throw MappableError.typeError(message: "Unable to unrwap value")
  }
  return rhs
}

public prefix func <- <T>(rhs: T) throws -> T {
  return rhs
}

public prefix func <? <T: DefaultType>(value: T?) -> T {
  return value ?? T.defaultValue
}

public func <- <T>(left: inout T, right: T) {
  left = right
}

public func <- <T>(left: inout T, right: T?) {
  guard let right = right else { return }

  left = right
}

public func <+ <T>(left: inout [T], right: [T]?) {
  guard let right = right else { return }
  left.append(contentsOf: right)
}

public func <+ <T>(left: inout [T], right: T?) {
  guard let right = right else { return }
  left.append(right)
}
