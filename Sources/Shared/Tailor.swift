// MARK: - Error
public enum MappableError: Error {
  case typeError(message: String)
}

// MARK: - SubscriptKind

public enum SubscriptKind {
  case index(Int)
  case key(String)
}

extension SubscriptKind: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: IntegerLiteralType) {
    self = .index(value)
  }
}

extension SubscriptKind: ExpressibleByStringLiteral {
  public typealias UnicodeScalarLiteralType = StringLiteralType
  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self = .key("\(value)")
  }

  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self = .key(value)
  }

  public init(stringLiteral value: StringLiteralType) {
    self = .key(value)
  }
}
