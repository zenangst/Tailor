prefix operator <?
infix operator <-

public prefix func <? <T: DefaultType>(value: T?) -> T {
  return value ?? T.defaultValue
}

public func <- <T>(left: inout T, right: T?) {
  guard let right = right else { return }

  left = right
}
