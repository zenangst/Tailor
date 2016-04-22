import Foundation
import Sugar

// MARK: - Error

public enum MappableError: ErrorType {
  case TypeError(message: String)
}

// MARK: - SubscriptKind

public enum SubscriptKind {
  case Index(Int)
  case Key(String)
}

extension SubscriptKind: IntegerLiteralConvertible {
  public init(integerLiteral value: IntegerLiteralType) {
    self = .Index(value)
  }
}

extension SubscriptKind: StringLiteralConvertible {
  public typealias UnicodeScalarLiteralType = StringLiteralType
  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self = .Key("\(value)")
  }

  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self = .Key(value)
  }

  public init(stringLiteral value: StringLiteralType) {
    self = .Key(value)
  }
}
