/**
 Anything that has default value
*/
public protocol DefaultType {
  static var defaultValue: Self { get }
}

extension String: DefaultType {
  public static var defaultValue: String {
    return ""
  }
}

extension Int: DefaultType {
  public static var defaultValue: Int {
    return 0
  }
}

extension Double: DefaultType {
  public static var defaultValue: Double {
    return 0
  }
}

extension Float: DefaultType {
  public static var defaultValue: Float {
    return 0
  }
}

extension Bool: DefaultType {
  public static var defaultValue: Bool {
    return false
  }
}

extension Array: DefaultType {
  public static var defaultValue: Array {
    return []
  }
}

extension Dictionary: DefaultType {
  public static var defaultValue: Dictionary {
    return [:]
  }
}
