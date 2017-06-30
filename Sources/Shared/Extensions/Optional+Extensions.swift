import Foundation

public extension Optional {
  /// Unwrap value or throw if there isn't
  func unwrapOrThrow() throws -> Wrapped {
    switch self {
    case .some(let value):
      return value
    case .none:
      throw MappableError.typeError(message: "Can't unwrap")
    }
  }

  /// Perform an action if not nil
  func performIfNotNil(block: (Wrapped) -> Void) {
    if case .some(let value) = self {
      block(value)
    }
  }
}
