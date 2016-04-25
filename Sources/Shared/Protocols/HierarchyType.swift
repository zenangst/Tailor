import Foundation
import Sugar

public protocol HierarchyType {

  /**
   Return a corresponding subclass
  */
  static func cluster(map: JSONDictionary) -> AnyObject
}
